//
//  Player.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation
import AVFoundation

protocol PlayerProtocol {
    func playSound(song: MediaItem) 
    func pauseSound(song: MediaItem)
    func stopSound(song: MediaItem)
    var showAlert: ((String, String, (() -> Void)?) -> Void)? { get set }
}

final class Player: PlayerProtocol {

    fileprivate var player: AVAudioPlayer?
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func playSound(song: MediaItem) {
        
        guard let url = song.localPathToFile else {
            return }
        if player?.url == url {
            player?.play()
            song.changeState(.played)
        } else {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                song.changeState(.played)
            } catch {
                showAlert?("Error player", "Can't play this song", nil)
                print(error.localizedDescription)
            }
        }
    }
    func pauseSound(song: MediaItem) {
        player?.pause()
        song.changeState(.paused)
        
    }
    func stopSound(song: MediaItem) {
        player?.stop()
        song.changeState(.downloaded)
        
    }
}
