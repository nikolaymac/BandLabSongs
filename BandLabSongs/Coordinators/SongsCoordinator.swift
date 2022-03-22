//
//  SongsCoordinator.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import Foundation
import UIKit
protocol SongsCoordinatorDelegate: AnyObject {
    func showSongFullScreen()
}

final class SongsCoordinator: CoordinatorProtocol {

    private let assembly: AssemblyProtocol
    let navigationController: UINavigationController?
    
    init(assembly: AssemblyProtocol, navigationController: UINavigationController?) {
        self.assembly = assembly
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = assembly.songsScreen(coordinatorDelegate: self)
        navigationController?.viewControllers = [vc]
    }
    
}

extension SongsCoordinator: SongsCoordinatorDelegate {
    //For example for transition to other vc
    func showSongFullScreen() {
        print("OK I PUSH NEW VC")
    }
}
