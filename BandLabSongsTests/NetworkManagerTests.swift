//
//  NetworkManagerTests.swift
//  BandLabSongsTests
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import XCTest
@testable import BandLabSongs

class NetworkManagerTests: XCTestCase {
    
    func testURLwithGETMethod() throws {

        let netW = NetworkManager()
        let endPoint = MockWrongEndPoint.testGet
        let url = netW.createUrl(for: endPoint)
        
        XCTAssert(url != nil, "URL not be nil")
        XCTAssertEqual(url?.absoluteString, "https://test.ru/testAction?q=testQ")
    
    }
    
    func testDecoderWrongData() throws {

        struct TestStruct: Decodable {
            var nameTest: String
            var age: Int
            var car: String
        }
        
        let netW = NetworkManager()
        var isError = false
        let jsonString = "{\"name\":\"John\", \"age\":30, \"car\":null}"
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        netW.decodeRespose(data: jsonData!, responseType: TestStruct.self) { result in
            switch result {
            case .success(let object):
                print(object)
            case .failure(let error):
                if error as! NetworkResponseError == NetworkResponseError.unableToDecode{
                    isError = true
                }
            }
        }
        XCTAssert(isError, "ERROR must be TRUE")

    }
    func testDecoderCorrectData() throws {

        struct TestStruct: Decodable {
            var name: String
            var age: Int
            var car: String?
        }
        
        let netW = NetworkManager()
        var isError = false
        let jsonString = "{\"name\":\"John\", \"age\":30, \"car\":null}"
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        netW.decodeRespose(data: jsonData!, responseType: TestStruct.self) { result in
            switch result {
            case .success(let object):
                print(object)
            case .failure:
                isError = true
            }
        }
        XCTAssert(!isError, "ERROR must be FALSE")

    }

}
