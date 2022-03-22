//
//  AppDelegate.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        startApp()
        
        return true
    }
    
    func startApp() {
        if let window = window {
            NetworkMonitor.shared.startMonitor()
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            appCoordinator = AppCoordinator(window: window, assembly: Assembly())
            appCoordinator?.start()
        }
    }
    
}

