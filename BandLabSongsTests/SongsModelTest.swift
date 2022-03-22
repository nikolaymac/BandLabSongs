//
//  SongsModelTest.swift
//  BandLabSongsTests
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import XCTest
@testable import BandLabSongs

class SongsModelTest: XCTestCase {
    
    func testEmptySongsFromStorage() throws {

        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .emptySongs)
        let loader = MockLoader()
        let player = MockPlayer()
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)

        storage.save(songs: [])
        model.setup()
        XCTAssertEqual(model.items.count, 0)
    }
    func testTwoSongsFromStorage() throws {

        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .emptySongs)
        let loader = MockLoader()
        let player = MockPlayer()
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)
        storage.save(songs: [Song(id: "1", name: "Test1", audioURL: "https://test.ru"), Song(id: "2", name: "Test2", audioURL: "https://test2.ru")])

        model.setup()
        XCTAssertEqual(model.items.count, 2)
        XCTAssertEqual(model.items.first?.name, "Test1")
    }
    func testSongsFromServer() throws {
        
        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .success)
        let loader = MockLoader()
        let player = MockPlayer()
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)

        let expectation = expectation(description: #function)
        model.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
        XCTAssertEqual(model.items.count, 1)
    
    }
    func testErrorAlertSongsFromServer() throws {
        
        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .errorLoad)
        let loader = MockLoader()
        let player = MockPlayer()
        
        var errorTitle = ""
        var errorMessage = ""
        
       
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)
        model.showAlert = {title, message,_ in
            errorTitle = title
            errorMessage = message
        }
        let expectation = expectation(description: #function)
        model.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
        XCTAssert(!errorTitle.isEmpty, "errorTitle not be empty")
        XCTAssert(!errorMessage.isEmpty, "errorTitle not be empty")
    
    }
    
    func testPressButtonSongDonwload() throws {
        
        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .success)
        let loader = MockLoader()
        let player = MockPlayer()
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)
        let expectation = expectation(description: #function)
        model.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            model.items.first?.changeState(.needToDownload)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        model.pressButton(model.items.first!)
        XCTAssertEqual(loader.songsDownloadTasks.count, 1)
       
    
    }
    func testPressButtonSongAlreadyDonwloaded() throws {
        
        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .success)
        let loader = MockLoader()
        let player = MockPlayer()
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)
        let expectation = expectation(description: #function)
        model.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            model.items.first?.changeState(.downloaded)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        model.pressButton(model.items.first!)
        XCTAssertEqual(loader.songsDownloadTasks.count, 0)
       
    
    }
    
    func testUpdateDataSongs() throws {
        
        let storage = MockStorage()
        let network = MockNetworkManager(testCase: .success)
        let loader = MockLoader()
        let player = MockPlayer()
        var isUpdated = false
        
        let model = SongsViewModel(networkManager: network, mediaLoader: loader, storage: storage, player: player)
        model.updateSongsData = {
            isUpdated = true
        }
        let expectation = expectation(description: #function)
        model.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
        XCTAssert(isUpdated, "isUpdated must be TRUE")
       
    
    }
    

}
