//
//  NetworkManager.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 20.03.2022.
//

import Foundation

typealias ResponseCompletion<T: Decodable> = (Result<T, Error>) -> Void

protocol NetworkManagerProtocol {
    func createUrl(for endPoint: EndPoint) -> URL? 
    func request<T: Decodable>(endPoint: EndPoint, responseType: T.Type, completion: @escaping ResponseCompletion<T>)
    func decodeRespose<T: Decodable>(data: Data, responseType:T.Type, completion: @escaping ResponseCompletion<T>)
}

class NetworkManager: NetworkManagerProtocol {
    
    private let session: URLSession
    
    
    init(){
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.requestCachePolicy = .reloadRevalidatingCacheData
        session = URLSession(configuration: config)
    }
    
    func createUrl(for endPoint: EndPoint) -> URL? {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.baseURL
        components.path = endPoint.path
        components.queryItems = endPoint.parameters
        
        return components.url
    }
   
    func request<T: Decodable>(endPoint: EndPoint, responseType: T.Type,  completion: @escaping ResponseCompletion<T>) {
        
        if !NetworkMonitor.shared.isConnectionInternet{
            completion(.failure(NetworkResponseError.noInternetConnection))
            return
        }
        
        guard let url = createUrl(for:endPoint ) else {
            completion(.failure(NetworkResponseError.wrongUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method.rawValue
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkResponseError.noData))
                return
            }
            self.decodeRespose(data: data, responseType: responseType, completion: completion)
        }
        
        dataTask.resume()
        
    }
    
    func decodeRespose<T: Decodable>(data: Data, responseType:T.Type, completion: @escaping ResponseCompletion<T>){
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(objects))
            }
        } catch {
            completion(.failure(NetworkResponseError.unableToDecode))
            print(error)
        }
    }
    
}

enum NetworkResponseError: Error {
    case noInternetConnection
    case wrongUrl
    case noData
    case unableToDecode
}
extension NetworkResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connections"
        case .wrongUrl:
            return "Incorrect URL"
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        }
    }
}
