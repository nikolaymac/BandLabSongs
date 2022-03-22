//
//  Assembly.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import Foundation
import UIKit

protocol AssemblyProtocol: AnyObject {
    func songsScreen(coordinatorDelegate: SongsCoordinatorDelegate) -> UIViewController
}

class Assembly: AssemblyProtocol {

    func songsScreen(coordinatorDelegate: SongsCoordinatorDelegate) -> UIViewController {

        let viewModel = SongsViewModel(networkManager: NetworkManager(),
                                       mediaLoader: MediaLoader.shared,
                                       storage: Storage(),
                                       player: Player())
        
        viewModel.delegateCoordinator = coordinatorDelegate
        
        let vc = SongsViewController(viewModel: viewModel)
        return vc
    }
}
