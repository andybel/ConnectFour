//
//  ViewController.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

class ViewController: UIViewController {

    private var gameManager = GameManager(columnCount: 7, rowCount: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager.logCurrentState()
    }
}
