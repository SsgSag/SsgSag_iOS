//
//  InterestPartVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class PreferenceVC: UIViewController {

    @IBOutlet var intersetButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
