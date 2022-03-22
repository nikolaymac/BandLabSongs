//
//  LoaderMocks.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation

class MockLoader: LoaderMediaProtocol{
    var songsDownloadTasks: [URL : DownloadMediaTask] = [:]
    
    func startDownload(_ song: MediaItem) {
        guard let urlString = song.url, let url = URL(string: urlString) else {return}
        guard songsDownloadTasks[url] == nil else {return}
        
        let download = DownloadMediaTask(item: song)
        download.item.changeState(.downloading)
        songsDownloadTasks[url] = download
    }
    
    func stopAllTasks() {
        songsDownloadTasks.removeAll()
    }
    
    var updateProgress: ((MediaItem) -> Void)?
    
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
    
}
