//
//  NetworkMocks.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation

enum MockWrongEndPoint: EndPoint{

    case testGet
    case testPost

    var scheme: String{
        return "https"
    }

    var baseURL: String {
        return "test.ru"
    }

    var path: String {
        return "/testAction"
    }

    var parameters: [URLQueryItem] {
        return [URLQueryItem(name: "q", value: "testQ")]
    }
    
    var method: Method{
        switch self{
            case .testGet:
                return .get
            case .testPost:
                return .post
        }
    }



}
//protocol URLSessionProtocol {
//
//    func downloadTask(with url: URL) -> URLSessionDownloadTaskProtocol
//}
//protocol URLSessionDownloadTaskProtocol {
//    func resume()
//    func cancel()
//}
//extension URLSessionDownloadTask: URLSessionDownloadTaskProtocol {}
//
//extension URLSession: URLSessionProtocol {
//    func downloadTask(with url: URL) -> URLSessionDownloadTaskProtocol {
//        return downloadTask(with: url) as URLSessionDownloadTask
//    }
//    
//    
//    
//}
class MockNetworkManager: NetworkManagerSongsProtocol {
    enum TestCase{
        case emptySongs
        case errorLoad
        case success
    }
    var testCase = TestCase.success
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    func getAllSongs(completion: @escaping ResponseCompletion<[Song]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            switch self.testCase {
            case .emptySongs:
                return completion(.success([]))
            case .errorLoad:
                return completion(.failure(NetworkResponseError.noData))
            case .success:
                return completion(.success([Song(id: "1", name: "Test1", audioURL: "https://test.ru")]))
            }
        }
    }
    
}
