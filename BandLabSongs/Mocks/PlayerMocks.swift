//
//  PlayerMocks.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation
class MockPlayer: PlayerProtocol {
    func stopSound(song: MediaItem) {
        
    }
    
    var showAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func playSound(song: MediaItem) {
        
    }
    func pauseSound(song: MediaItem) {
        
    }
    
}
