//
//  ReviewPrepareViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewPrepareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubTypeVC") as? SelectClubTypeViewController else {return}
        nextVC.registerType = .Review
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
