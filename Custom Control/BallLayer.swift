//
//  BallLayer.swift
//  Custom Control
//
//

import UIKit

class BallLayer: CAShapeLayer {
    
    override func action(forKey event: String) -> CAAction? {
        
        return nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fillColor = UIColor.black.cgColor
        
        contentsScale = UIScreen.main.scale
        
        drawsAsynchronously = true
        
        needsDisplayOnBoundsChange = true
        
        setNeedsDisplay()
        
    }
    
}
