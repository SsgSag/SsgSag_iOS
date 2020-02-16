//
//  ReviewPrepareViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewPrepareViewController: UIViewController {

    var isExistClub = false
    var clubactInfo: ClubActInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        
        if isExistClub {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FoundClubVC") as? FoundClubViewController else {return}
            nextVC.clubactInfo = clubactInfo
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubTypeVC") as? SelectClubTypeViewController else {return}
            nextVC.registerType = .Review
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension ReviewPrepareViewController: UIGestureRecognizerDelegate {}
