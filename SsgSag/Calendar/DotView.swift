//
//  DotView.swift
//  SsgSag
//
//  Created by CHOMINJI on 02/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DotView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var dotView1: UIView!
    @IBOutlet weak var dotView2: UIView!
    @IBOutlet weak var dotView3: UIView!
    @IBOutlet weak var dotView4: UIView!
    @IBOutlet weak var dotView5: UIView!
    
    
    
//
//    override init(frame: CGRect) { //for using CustomView in code
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) { //for using customView in IB
//        super.init(coder: aDecoder)
////        commonInit()
//    }
//
//    private func commonInit() {
//        Bundle.main.loadNibNamed("DotView", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
//    }
    
    private let xibName = "DotView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        dotView2.isHidden = true
        dotView3.isHidden = true
        dotView4.isHidden = true
        dotView5.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotView1.circleView()
        dotView2.circleView()
        dotView3.circleView()
        dotView4.circleView()
        dotView5.circleView()
    }

}
