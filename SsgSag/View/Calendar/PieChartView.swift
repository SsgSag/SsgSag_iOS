//
//  PieChartView.swift
//  SsgSag
//
//  Created by 이혜주 on 19/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let shapeLayer = CAShapeLayer()
        let shapeLayer2 = CAShapeLayer()
        let shapeLayer3 = CAShapeLayer()
        let shapeLayer4 = CAShapeLayer()
        
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: frame.width / 4,
                                        startAngle: 0,
                                        endAngle: .pi,
                                        clockwise: true)
        
        let circularPath2 = UIBezierPath(arcCenter: center,
                                         radius: frame.width / 4,
                                         startAngle: 0,
                                         endAngle: .pi * 7/4,
                                         clockwise: true)
        
        let circularPath3 = UIBezierPath(arcCenter: center,
                                         radius: frame.width / 4,
                                         startAngle: 0,
                                         endAngle: .pi * 4/3,
                                         clockwise: true)
        
        let circularPath4 = UIBezierPath(arcCenter: center,
                                         radius: frame.width / 4,
                                         startAngle: 0,
                                         endAngle: .pi * 2,
                                         clockwise: true)
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = frame.width / 2
        
        shapeLayer.strokeEnd = 0
        
        shapeLayer2.path = circularPath2.cgPath
        shapeLayer2.strokeColor = #colorLiteral(red: 0.4588235294, green: 0.5182471275, blue: 1, alpha: 0.7)
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = frame.width / 2
        
        shapeLayer2.strokeEnd = 0
        
        shapeLayer3.path = circularPath3.cgPath
        shapeLayer3.strokeColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.5)
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.lineWidth = frame.width / 2
        
        shapeLayer3.strokeEnd = 0
        
        shapeLayer4.path = circularPath4.cgPath
        shapeLayer4.strokeColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.3)
        shapeLayer4.fillColor = UIColor.clear.cgColor
        shapeLayer4.lineWidth = frame.width / 2
        
        shapeLayer4.strokeEnd = 0
        
        layer.addSublayer(shapeLayer)
        layer.addSublayer(shapeLayer2)
        layer.addSublayer(shapeLayer3)
        layer.addSublayer(shapeLayer4)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 1
        animation.duration = 2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "urSoBasic")
        shapeLayer2.add(animation, forKey: "urSoBasic")
        shapeLayer3.add(animation, forKey: "urSoBasic")
        shapeLayer4.add(animation, forKey: "urSoBasic")
    }
}
