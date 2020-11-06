//
//  TurnLabel.swift
//  ConnectFour
//
//  Created by Andy Bell on 06.11.20.
//

import UIKit

class TurnLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont.boldSystemFont(ofSize: 22.0)
        textColor = UIColor.label
        textAlignment = .center
        
        clipsToBounds = true
        layer.cornerRadius = 20.0
        
        backgroundColor = UIColor.systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
