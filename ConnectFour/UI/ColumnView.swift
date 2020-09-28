//
//  ColumnView.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

class ColumnView: UIView {

    func addDiscWithColor(_ color: UIColor) {
     
        let bottomOffset = CGFloat(subviews.count) * (bounds.size.height / 6)
    
        let discView = DiscView(frame: .zero)
        discView.backgroundColor = color
        discView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(discView)

        NSLayoutConstraint.activate([
            discView.widthAnchor.constraint(equalTo: widthAnchor),
            discView.heightAnchor.constraint(equalTo: widthAnchor),
            discView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomOffset)
        ])
    }
}
