//
//  SongModel.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

struct SongsResponse: Decodable {
    let data: [Song]?
}
protocol MediaItem {
    var id: String? { get }
    var name: String? { get }
    var url: String? { get }
    var state: StateSong { get }
    var localPathToFile: URL? { get }
    var progressValue: Float { get set }
    func changeState(_ new: StateSong)
    func saveLocalPath(_ url: URL)
}

class Song: Codable, MediaItem {
   
    let id: String?
    let name: String?
    let audioURL: String?
    var url: String? {
        return audioURL
    }
    var state: StateSong = .needToDownload
    var localPathToFile: URL?
    var progressValue: Float = 0
    
    init(id: String?, name: String?, audioURL: String?) {
        self.id = id
        self.name = name
        self.audioURL = audioURL
    }
    private enum CodingKeys: String, CodingKey {
           case id, name, audioURL
    }
    func changeState(_ new: StateSong){
        self.state = new
        if new != .downloading{
            progressValue = 0
        }
    }
    func saveLocalPath(_ url: URL){
        self.localPathToFile = url
    }
}

enum StateSong: Codable {
    case needToDownload
    case downloading
    case downloaded
    case played
    case paused
}
