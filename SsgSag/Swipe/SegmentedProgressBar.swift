//
//  SegmentedProgressBar.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 26..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import Foundation
import UIKit

protocol SegmentedProgressBarDelegate: class {
    func segmentedProgressBarChangedIndex(index: Int)
    func segmentedProgressBarFinished()
}

class SegmentedProgressBar: UIView {
    
    weak var delegate: SegmentedProgressBarDelegate?
    var topColor = UIColor.gray {
        didSet {
            //topColor 변경된 직후에 호출
            self.updateColors()
        }
    }
    var bottomColor = UIColor.gray.withAlphaComponent(0.25) {
        didSet {
            self.updateColors()
        }
    }
    var padding: CGFloat = 2.0
    var isPaused: Bool = false {
        didSet {
            for segment in segments {
                let layer = segment.topSegmentView.layer
                //                let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                layer.speed = 0.0
                //                layer.timeOffset = pausedTime
                //            if isPaused {
                //                for segment in segments {
                //                    let layer = segment.topSegmentView.layer
                //                    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                //                    layer.speed = 0.0
                //                    layer.timeOffset = pausedTime
                //                }
                //            } else {
                //                let segment = segments[currentAnimationIndex]
                //                let layer = segment.topSegmentView.layer
                //                let pausedTime = layer.timeOffset
                //                layer.speed = 1.0
                //                layer.timeOffset = 0.0
                //                layer.beginTime = 0.0
                ////                let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                //                layer.beginTime = timeSincePause
            }
        }
    }
    
    private var segments = [Segment]()
    //    var duration: TimeInterval
    private var hasDoneLayout = false // hacky way to prevent layouting again
    var currentAnimationIndex = 0
    
    
    init(numberOfSegments: Int) {
        //        self.duration = duration
        super.init(frame: CGRect.zero)
        
        for _ in 0..<numberOfSegments {
            let segment = Segment()
            addSubview(segment.bottomSegmentView)
            addSubview(segment.topSegmentView)
            segments.append(segment)
        }
        
        self.updateColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasDoneLayout {
            return
        }
        let width = (frame.width - (padding * CGFloat(segments.count - 1)) ) / CGFloat(segments.count)
        for (index, segment) in segments.enumerated() {
            let segFrame = CGRect(x: CGFloat(index) * (width + padding), y: 0, width: width, height: frame.height)
            segment.bottomSegmentView.frame = segFrame
            segment.topSegmentView.frame = segFrame
            segment.topSegmentView.frame.size.width = 0
            
            let cr = frame.height / 2
            segment.bottomSegmentView.layer.cornerRadius = cr
            segment.topSegmentView.layer.cornerRadius = cr
            //TODO: 색깔 바꾸기
            if currentAnimationIndex == 0 {
                let currentSegment = segments[currentAnimationIndex]
                currentSegment.bottomSegmentView.backgroundColor = #colorLiteral(red: 0.9386122227, green: 0.9386122227, blue: 0.9386122227, alpha: 1)
                currentSegment.topSegmentView.backgroundColor = #colorLiteral(red: 0.9386122227, green: 0.9386122227, blue: 0.9386122227, alpha: 1)
            }
        }
        hasDoneLayout = true
    }
    
    func startAnimation() {
        layoutSubviews()
        animate()
    }
    
    private func animate(animationIndex: Int = 1) {
        let nextSegment = segments[animationIndex]
        currentAnimationIndex = animationIndex
//        if currentAnimationIndex == 0 {
//            let currentSegment = segments[currentAnimationIndex]
//            currentSegment.bottomSegmentView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//            currentSegment.topSegmentView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//        }
        self.isPaused = false // no idea why we have to do this here, but it fixes everything :D
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveLinear, animations: {
            nextSegment.topSegmentView.frame.size.width = nextSegment.bottomSegmentView.frame.width
        }) { (finished) in
            if !finished {
                return
            }
            self.next()
        }
    }
    
    private func updateColors() {
        for segment in segments {
            segment.topSegmentView.backgroundColor = topColor
            segment.bottomSegmentView.backgroundColor = bottomColor
        }
    }
    
    private func next() {
        let newIndex = self.currentAnimationIndex + 1
        print("newIndex: \(newIndex)")
        if newIndex < self.segments.count {
            self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
            self.animate(animationIndex: newIndex)
        } else {
            self.delegate?.segmentedProgressBarFinished()
        }
    }
    
    func skip() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
        currentSegment.topSegmentView.layer.removeAllAnimations()
        self.next()
    }
    
    func rewind() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.layer.removeAllAnimations()
        currentSegment.topSegmentView.frame.size.width = 0
        let newIndex = max(currentAnimationIndex - 1, 0)
        let prevSegment = segments[newIndex]
        prevSegment.topSegmentView.frame.size.width = 0
        self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
        self.animate(animationIndex: newIndex)
        startAnimation()
    }
    
    func cancel() {
        for segment in segments {
            segment.topSegmentView.layer.removeAllAnimations()
            segment.bottomSegmentView.layer.removeAllAnimations()
        }
    }
}

fileprivate class Segment {
    let bottomSegmentView = UIView()
    let topSegmentView = UIView()
    init() {
    }
}
