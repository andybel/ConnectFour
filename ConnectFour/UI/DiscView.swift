//
//  DiscView.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

class DiscView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
        
        layer.borderWidth = 6.0
        layer.borderColor = UIColor.systemGray6.cgColor
    }
}
