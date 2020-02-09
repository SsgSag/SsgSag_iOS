//
//  SelectClubTypeViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

enum RegisterType {
    case Club, Review
}
class SelectClubTypeViewController: UIViewController {

    var registerType: RegisterType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func nextProcessReviewRegister(clubType: ClubType) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InputUserClubInfoVC") as! InputUserClubInfoViewController
        nextVC.clubactInfo = ClubActInfoModel(clubType: clubType)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func nextProcessClubRegister(clubType: ClubType) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubManagerRegisterOneStepVC") as! ClubManagerRegisterOneStepViewController
        nextVC.viewModel = ClubRegisterOneStepViewModel()
        nextVC.model = ClubRegisterModel(clubType: clubType)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func clubTypeClick(_ sender: UIButton) {
        
        let type: ClubType = sender.tag == 1 ? .School : .Union
        
        registerType == RegisterType.Review ? nextProcessReviewRegister(clubType: type) : nextProcessClubRegister(clubType: type)
            
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
