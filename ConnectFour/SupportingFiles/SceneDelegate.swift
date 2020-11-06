//
//  SceneDelegate.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let mainVC = window?.rootViewController as? ViewController else {
            fatalError("The root VC of the main wndow is not what we are expecting! (ViewController type)")
        }
        
        let gameManager = GameManager(grid: GameGrid(columns: 7, rows: 6))
        let configLoader = ConfigLoader()
        let viewModel = ViewModelDefault(gameManager: gameManager, configLoader: configLoader)
        mainVC.viewModel = viewModel
    }
}

