//
//  LineView.swift
//  SsgSag
//
//  Created by CHOMINJI on 03/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    @IBOutlet weak var lineStackView: UIStackView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var lineView4: UIView!
    @IBOutlet weak var lineView5: UIView!
    
    @IBOutlet weak var lineTitle1: UILabel!
    @IBOutlet weak var lineTitle2: UILabel!
    @IBOutlet weak var lineTitle3: UILabel!
    
    
    private let xibName = "LineView"
    
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
        
        lineView2.isHidden = true
        lineView3.isHidden = true
        lineView4.isHidden = true
        lineView5.isHidden = true
        
        lineTitle2.isHidden = true
        lineTitle3.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
