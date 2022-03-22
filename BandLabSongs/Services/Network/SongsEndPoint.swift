//
//  SongsEndPoint.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

enum SongsEndPoint: EndPoint {
    
    case getSongsList
    
    
    
    var scheme: String {
        return "https"
    }

    var baseURL: String {
    
        return "gist.githubusercontent.com"
    }
    
    var path: String {
        switch self {
            case .getSongsList:
                return "/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"
        }
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
    
    var method: Method{
        switch self{
            case .getSongsList:
                return .get
        }
    }
    
}
