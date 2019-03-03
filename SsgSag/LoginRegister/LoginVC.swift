//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        popUpSocialLogin(button: sender)
    }
    
    @IBAction func touchUpAutoLoginButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named:"checkboxRound"), for: .normal)
            
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            sender.isSelected = true
        }
    }
    
    func popUpSocialLogin(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "LoginPopUp")
        self.addChild(popVC)
        
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
    }
}
