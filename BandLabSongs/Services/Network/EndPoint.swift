//
//  EndPoint.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPoint {

    var scheme: String { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
     
    var method: Method { get }
}
