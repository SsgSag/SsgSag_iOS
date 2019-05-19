//
//  AppInfoViewController.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var outline: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "앱 정보"
    
        
        
    }

}
