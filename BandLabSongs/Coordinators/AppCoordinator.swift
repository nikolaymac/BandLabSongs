//
//  AppCoordinator.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController?{ get }
    func start()
}

final class AppCoordinator: CoordinatorProtocol {
    
     let window: UIWindow
     let navigationController: UINavigationController?
     var mainCoordinator: CoordinatorProtocol?
    
    private let assembly: AssemblyProtocol
    
    
    init(window: UIWindow, assembly: AssemblyProtocol, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.window.backgroundColor = .white
        self.assembly = assembly
        self.navigationController = navigationController
        setupWindow()
        setupMainCoordinator()
    }
    
    private func setupWindow() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    private func setupMainCoordinator(){
        mainCoordinator = SongsCoordinator(assembly: assembly, navigationController: navigationController)
    }
    
    func start() {
        mainCoordinator?.start()
    }
}
