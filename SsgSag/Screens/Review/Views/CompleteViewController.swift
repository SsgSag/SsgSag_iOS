//
//  CompleteViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var subText = ""
    var titleText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        subLabel.text = subText
    }
    
    @IBAction func dismissClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
