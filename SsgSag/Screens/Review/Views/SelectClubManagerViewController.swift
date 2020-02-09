//
//  SelectClubManagerViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SelectClubManagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        registertype넘기기
    }
    
    @IBAction func clubManagerClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubTypeVC") as! SelectClubTypeViewController
        nextVC.registerType = .Club
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func notClubManagerClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NoClubManagerVC") as! NoClubManagerViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
