//
//  SelectClubTypeViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SelectClubTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func clubTypeClick(_ sender: UIButton) {
        
        let type: ClubType = sender.tag == 1 ? .School : .Union
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InputUserClubInfoVC") as! InputUserClubInfoViewController
        nextVC.clubactInfo = ClubActInfoModel(clubType: type)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
