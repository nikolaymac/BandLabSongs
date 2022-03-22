//
//  SongsViewModel.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation
import AVFoundation

protocol SongsViewModelClientProtocol: SongViewDelegate {
    var updateSongsData: (() -> Void)? {get set}
    var updateOneSongByIndex: ((Int) -> Void)? {get set}
    var showAlert: ((String, String, (() -> Void)?) -> Void)? {get set}
    
    var items: [MediaItem] {get set}
   
    func setup()
    func refreshData()
    func tapOnSong(by index: Int)
    
}
protocol SongsViewModelClassProtocol: SongsViewModelClientProtocol {
    
    var networkManager: NetworkManagerSongsProtocol { get }
    var mediaLoader: LoaderMediaProtocol { get }
    var storage: StorageProtocol { get }
    var player: PlayerProtocol { get }
    
}

final class SongsViewModel: NSObject, SongsViewModelClassProtocol {
   
    weak var delegateCoordinator: SongsCoordinatorDelegate?
    
    let networkManager: NetworkManagerSongsProtocol
    let storage: StorageProtocol
    var player: PlayerProtocol
    var mediaLoader: LoaderMediaProtocol
    
    var items: [MediaItem] = []
    
    var updateSongsData: (() -> Void)?
    var updateOneSongByIndex: ((Int) -> Void)?
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
    fileprivate var currentMediaPlayed: MediaItem?
    
    init(networkManager: NetworkManagerSongsProtocol,
         mediaLoader: LoaderMediaProtocol,
         storage: StorageProtocol,
         player: PlayerProtocol){
        
        self.networkManager = networkManager
        self.mediaLoader = mediaLoader
        self.storage = storage
        self.player = player
        
    }
    
    func setup() {
        items = storage.getSongs()
        storage.checkDownloadedFiles(for: items)
        
        mediaLoader.updateProgress = { [weak self] song in
            self?.update(song)
        }
        mediaLoader.showAlert = showAlert
        player.showAlert = showAlert
        startLoadData()
    }
    
    @objc func refreshData(){
        stopPrevPlayed()
        mediaLoader.stopAllTasks()
        startLoadData()
    }
    
    private func update(_ song: MediaItem) {
        if let index = self.items.firstIndex(where: {$0.id == song.id}){
            self.updateOneSongByIndex?(index)
        }
    }
    
    private func startLoadData() {
       
        networkManager.getAllSongs { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let songs):
                self.storage.save(songs: songs)
                self.items = songs
                self.storage.checkDownloadedFiles(for: self.items)
                self.updateSongsData?()
            case .failure(let error):
                self.showAlert?("Error LoadData", error.localizedDescription, nil)
            }
        }
    }
    
    func tapOnSong(by index: Int) {
        delegateCoordinator?.showSongFullScreen()
    }
    
    fileprivate func stopPrevPlayed() {
        if let current = currentMediaPlayed {
            player.stopSound(song: current)
            update(current)
        }
    }

}
extension SongsViewModel: SongViewDelegate {
    func pressButton(_ item: MediaItem) {
        
        switch item.state {
        case .needToDownload:
            mediaLoader.startDownload(item)
        
        case .downloading:
            return
        case .downloaded:
            
            stopPrevPlayed()
            player.playSound(song: item)
            currentMediaPlayed = item
            
        case .paused:
            player.playSound(song: item)
        case .played:
            player.pauseSound(song: item)
        }
        update(item)
        
    }
}
