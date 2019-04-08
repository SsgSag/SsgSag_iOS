//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var autoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEmailAndPasswordTextField()
        
    }
    
    private func setEmailAndPasswordTextField() {
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
    }
    
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        popUpSocialLogin(button: sender)
    }
    
    @IBAction func touchUpAutoLoginButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            autoLoginButton.setImage(UIImage(named:"checkboxRound"), for: .normal)
        } else {
            sender.isSelected = true
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            sender.isSelected = true
        }
    }
    
    @IBAction func ssgSagLogin(_ sender: Any) {
        print("로그인")
    }
    
    @IBAction func ssgSagSignUp(_ sender: Any) {
        print("회원가입")
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
