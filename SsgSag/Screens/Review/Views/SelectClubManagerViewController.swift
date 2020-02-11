//
//  SelectClubManagerViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SelectClubManagerViewController: UIViewController {
    
    var isReviewExist = false
    var clubIdx = -1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clubManagerClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubTypeVC") as! SelectClubTypeViewController
        nextVC.registerType = .Club
        nextVC.isReviewExist = isReviewExist
        nextVC.clubIdx = clubIdx
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func notClubManagerClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NoClubManagerVC") as! NoClubManagerViewController
        nextVC.service = ClubService()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
