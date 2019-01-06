//
//  CustomControlView.swift
//  Custom Control
//
//

import Foundation

import UIKit

class CustomControlView: UIControl {

    let backdropLayer: CAShapeLayer = CAShapeLayer()
    
    let tempreatureLabel = UILabel()
    
    let ringWidth: CGFloat = CGFloat(40.0)
    
    var textFont: UIFont = UIFont.boldSystemFont(ofSize: 40)
    
    let maxTempreature: Double = 30
    
    var ballAngle: Int = 0 {
        
        didSet {
            
            var angle = ballAngle - 270
            
            if angle < 0 {
                
                angle += 360
                
            }
            
            let newTemp = Int(floor((Double(angle) / 360) * maxTempreature))
            
            tempreatureLabel.text = "\(newTemp)º"
            
        }
        
    }
    
    private var textFontSize: CGFloat {
        
        return textFont.pointSize
        
    }
    
    var halfRingWidth: CGFloat {
        
        return ringWidth / 2
        
    }
    
    private var centerPoint: CGPoint {
        
        return CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
    }
    
    private lazy var ballIndicator: CAShapeLayer = {
        
        return BallLayer()
        
    }()
    
    private var radius: CGFloat {
        
        return bounds.height / 2 - (ringWidth / 2.0)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tempreatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tempreatureLabel)
        
        tempreatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        tempreatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        tempreatureLabel.textAlignment = NSTextAlignment.center
        
        tempreatureLabel.font = textFont
        
        tempreatureLabel.textColor = UIColor.black
        
        tempreatureLabel.text = "0º"
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let circlePath: CGPath = UIBezierPath(ovalIn: CGRect(x: halfRingWidth, y: halfRingWidth, width: bounds.width - ringWidth, height: bounds.height - ringWidth)).cgPath
        
        backdropLayer.path = circlePath
        
        backdropLayer.lineWidth = ringWidth
        
        backdropLayer.strokeEnd = 1.0
        
        backdropLayer.fillColor = nil
        
        backdropLayer.strokeColor = UIColor(red: 112/255, green: 25/255, blue: 18/255, alpha: 1.0).cgColor
        
        layer.addSublayer(backdropLayer)
        
        let ballShape = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ringWidth, height: ringWidth))
        
        ballIndicator.path = ballShape.cgPath
        
        ballIndicator.frame = CGRect(x: 0, y: 0, width: ringWidth, height: ringWidth)
        
        ballIndicator.position = CGPoint(x: frame.width / 2, y: ringWidth / 2)
        
        layer.addSublayer(ballIndicator)
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.beginTracking(touch, with: event)
        
        let touchPosition = touch.location(in: self)
        
        let ballFrame = ballIndicator.frame
        
        if ballFrame.contains(touchPosition) {
            
            return true
            
        }
        
        return false
        
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let lastPoint = touch.location(in: self)
        
        moveBall(to: lastPoint)
        
        self.sendActions(for: UIControl.Event.valueChanged)
        
        return true
        
    }
    
    private func moveBall(to point: CGPoint) {
        
        let currentAngle: Double = angleFromNorth(p1: centerPoint, p2: point)
        
        let angle = Int(floor(currentAngle))
        
        ballAngle = angle
        
        let actualAngle = Int(360 - angle)
        
        let handleCenter = pointFrom(angle: actualAngle)
        
        ballIndicator.position = handleCenter
        
    }
    
    func pointFrom(angle: Int) -> CGPoint {
        
        var result: CGPoint = CGPoint.zero
        
        let y = round(Double(radius) * sin(Double(-angle).degreesToRadians())) + Double(centerPoint.y)
        
        let x = round(Double(radius) * cos(Double(-angle).degreesToRadians())) + Double(centerPoint.x)
        
        result.y = CGFloat(y)
        
        result.x = CGFloat(x)
        
        return result
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        layoutSubviews()
        
    }
    
    func angleFromNorth(p1: CGPoint, p2: CGPoint) -> Double {
        
        var v: CGPoint  = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
        
        let vmag: CGFloat = sqrt((v.x * v.x) + (v.y * v.y))
        
        var result: Double = 0.0
        
        v.x /= vmag
        
        v.y /= vmag
        
        let radians = Double(atan2(v.y, v.x))
        
        result = radians.radiansToDegrees()
        
        let finalResult = result >= 0  ? result : result + 360.0
        
        return finalResult
        
    }

}

private extension Double {
    
    func degreesToRadians() -> Double {
        
        return self * Double.pi / 180.0
        
    }
    
    func radiansToDegrees() -> Double {
        
        return self * 180.0 / Double.pi
        
    }
    
}

