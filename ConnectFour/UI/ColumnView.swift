//
//  ColumnView.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

class ColumnView: UIView {
    
    private var animator: UIDynamicAnimator!

    private let collisionBoundary = UICollisionBehavior()
    private let gravity = UIGravityBehavior()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        
        gravity.magnitude = 5.0
        animator = UIDynamicAnimator(referenceView: self)
        self.animator.addBehavior(gravity)
        collisionBoundary.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBoundary)
    }

    func addDiscWithColor(_ color: UIColor) {
     
        let dim = bounds.size.width - 3
        let discView = DiscView(frame: CGRect(x: 3, y: 3, width: dim, height: dim))
        discView.backgroundColor = color
        addSubview(discView)
        gravity.addItem(discView)
        collisionBoundary.addItem(discView)
    }
    
    func clearDiscs() {
        
        for disc in subviews where disc.isKind(of: DiscView.self) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.0...0.3)) {
                self.collisionBoundary.removeItem(disc)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.gravity.removeItem(disc)
                    disc.removeFromSuperview()
                }
            }
        }
    }
}
