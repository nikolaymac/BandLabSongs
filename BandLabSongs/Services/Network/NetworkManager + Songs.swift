//
//  NetworkManager + Songs.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

protocol NetworkManagerSongsProtocol {
    func getAllSongs(completion: @escaping ResponseCompletion<[Song]>)
}

extension NetworkManager: NetworkManagerSongsProtocol {
    
    func getAllSongs(completion: @escaping ResponseCompletion<[Song]>) {
        request(endPoint: SongsEndPoint.getSongsList, responseType: SongsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
    
        }
    }
    
}
