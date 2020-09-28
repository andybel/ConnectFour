//
//  PlayerLabel.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

class PlayerLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numberOfLines = 0
        textAlignment = .center
        textColor = .white
        font = .boldSystemFont(ofSize: 24.0)
        
        clipsToBounds = true
        layer.cornerRadius = 20.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
