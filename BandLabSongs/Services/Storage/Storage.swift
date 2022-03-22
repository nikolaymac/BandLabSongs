//
//  Storage.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

protocol StorageProtocol {
    func save(songs: [Song])
    func getSongs() -> [Song]
    func checkDownloadedFiles(for items: [MediaItem])
}

final class Storage: StorageProtocol {
    
    private var downloadedFiles: [String : URL] = [:]
    private var songs: [Song] {
        get {
            if let encoded = UserDefaults.standard.object(forKey: SettingsApp.UserDefaultsKeys.songsCacheKey) as? Data, let songs = try? PropertyListDecoder().decode([Song].self, from: encoded) {
                return songs
            } else {
                return []
            }
        }
    
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: SettingsApp.UserDefaultsKeys.songsCacheKey)
        }
    }
    
    func getSongs() -> [Song]{
        return self.songs
    }
    
    func save(songs: [Song]){
        self.songs = songs
    }
    
    func checkDownloadedFiles(for items: [MediaItem]) {
        if items.isEmpty { return }
        scan(folder: SettingsApp.folderForSongs)
        
        for item in items {
            if let url = downloadedFiles[item.name ?? ""]{
                item.saveLocalPath(url)
                item.changeState(.downloaded)
            }
        }
    }
    
    private func scan(folder: String) {
        let folderUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(folder)
        
        do {
            if !FileManager.default.fileExists(atPath: folderUrl.path) {
                return
            }
            
            let files = try FileManager.default.contentsOfDirectory(
                at: folderUrl,
                includingPropertiesForKeys: nil
            )
            
            for fileUrl in files{
                if FileManager.isNotEmptySizeFile(path: fileUrl.path) {
                    self.downloadedFiles[fileUrl.lastPathComponent] = fileUrl
                }
            }
        } catch {
            print(error)
        }

    }
}
