//
//  StorageMocks.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation

class MockStorage: StorageProtocol {
  
    
    var arraySongsStorage: [Song] = []

    func save(songs: [Song]) {
        self.arraySongsStorage = songs
    }
    
    func getSongs() -> [Song] {

        return arraySongsStorage
    }
    func checkDownloadedFiles(for items: [MediaItem]) {
        
    }
    
    
}
