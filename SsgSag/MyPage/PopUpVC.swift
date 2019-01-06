//
//  PopUpVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 6..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        okButton.makeRounded(cornerRadius: 5)
        backView.makeRounded(cornerRadius: 5)
    }
    

    @IBAction func touchUpOkButton(_ sender: Any) {
         self.view.removeFromSuperview()
    }
    

}
