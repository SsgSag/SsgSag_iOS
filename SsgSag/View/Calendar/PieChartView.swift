//
//  PieChartView.swift
//  SsgSag
//
//  Created by 이혜주 on 19/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    let firstMajorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
        label.text = "label"
        return label
    }()
    
    let chartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstPersentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "label"
        return label
    }()
    
    let secondMajorAndPersentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        label.text = "label"
        return label
    }()
    
    let thirdMajorAndPersentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        label.text = "label"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let array: [CGFloat] = [40, 30 + 40, 20 + 30 + 40, 10 + 20 + 30 + 40]
        
        var color: [UIColor] = [#colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.7), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.5), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.3)]
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 1
        animation.duration = 2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        for i in 0..<array.count {
            let shapeLayer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: center,
                                    radius: frame.width / 4,
                                    startAngle: 0,
                                    endAngle: array[i] * (.pi / 180) * (360 / 100),
                                    clockwise: true)
            
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = color[i].cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = frame.width / 2
            
            shapeLayer.strokeEnd = 0
            
            layer.addSublayer(shapeLayer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.toValue = 1
            animation.duration = CFTimeInterval(1.5 * array[i] / 100)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            shapeLayer.add(animation, forKey: "urSoBasic")
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(firstMajorLabel)
        addSubview(chartView)
        addSubview(firstPersentLabel)
        addSubview(secondMajorAndPersentLabel)
        addSubview(thirdMajorAndPersentLabel)
        
        firstMajorLabel.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        firstMajorLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        firstMajorLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        
        chartView.topAnchor.constraint(
            equalTo: firstMajorLabel.bottomAnchor,
            constant: 11).isActive = true
        chartView.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        chartView.widthAnchor.constraint(
            equalToConstant: 68).isActive = true
        chartView.heightAnchor.constraint(
            equalToConstant: 68).isActive = true
        
        firstPersentLabel.centerXAnchor.constraint(
            equalTo: chartView.centerXAnchor).isActive = true
        firstPersentLabel.centerYAnchor.constraint(
            equalTo: chartView.centerYAnchor).isActive = true
        firstPersentLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        firstPersentLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        
        secondMajorAndPersentLabel.topAnchor.constraint(
            equalTo: chartView.bottomAnchor,
            constant: 6).isActive = true
        secondMajorAndPersentLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        secondMajorAndPersentLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        
        thirdMajorAndPersentLabel.topAnchor.constraint(
            equalTo: secondMajorAndPersentLabel.bottomAnchor).isActive = true
        thirdMajorAndPersentLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        thirdMajorAndPersentLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
    }
    
    func configureAnalyticsWith(analyticsData: Analytics?, rates: [Int]?) {
        guard let rates = rates else { return }
        
        var sumRates: [Int] = []
        
        for index in 0..<rates.count {
            var rate = 0
            
            for i in 0..<index {
                rate += rates[i]
            }
            
            sumRates.append(rate)
        }
        
        drawAnalytics(rates: sumRates)
    }
    
    private func drawAnalytics(rates: [Int]) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let array: [CGFloat] = [40, 30 + 40, 20 + 30 + 40, 10 + 20 + 30 + 40]
        
        var color: [UIColor] = [#colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.7), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.5), #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.3)]

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 1
        animation.duration = 2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
    
        for i in 0..<array.count {
            let shapeLayer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: center,
                                    radius: frame.width / 4,
                                    startAngle: 0,
                                    endAngle: array[i] * (.pi / 180) * (360 / 100),
                                    clockwise: true)
            
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = color[i].cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = frame.width / 2
            
            shapeLayer.strokeEnd = 0
            
            layer.addSublayer(shapeLayer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.toValue = 1
            animation.duration = CFTimeInterval(1.5 * array[i] / 100)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            shapeLayer.add(animation, forKey: "urSoBasic")
        }

    }
}
