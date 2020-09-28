//
//  DiscView.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

class DiscView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
    }
}
