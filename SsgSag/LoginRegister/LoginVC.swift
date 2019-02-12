//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        popUpSocialLogin(button: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let color1 = UIColor.rgb(red: 155, green: 65, blue: 250)
//        let color2 = UIColor.rgb(red: 35, green: 191, blue: 251)
//        let color3 = UIColor.rgb(red: 60, green: 234, blue: 252)
//        view.setGradientBackGround(colorOne: color1, colorTwo: color2, colorThree: color3)
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
    
//    @IBAction func touchUpLoginButton(_ sender: Any) {
//        guard let email = emailTextField.text else {return}
//        guard let password = passwordTextField.text else {return}
//        print("5")
//
//        LoginService.shared.login(email: email, password: password) { (data,status) in
//            //            print("this is data token \(data?.token) \(status)")
//            if data?.token == nil {
//                self.emailTextField.text = ""
//                self.passwordTextField.text = ""
//                print("500")
//                if status == 400 {
//                    print("400")
//                    let alertController = UIAlertController(title: "로그인 실패", message: "정확한 ID와 Password를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
//                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    alertController.addAction(action)
//                    self.present(alertController, animated: true, completion: nil)
//                } else if status == 500 {
//                    let alterController = UIAlertController(title: "로그인 실패", message: "서버 내부 에러", preferredStyle: UIAlertController.Style.alert)
//                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    alterController.addAction(action)
//                    self.present(alterController, animated: true, completion: nil)
//                }
//            }
//
//            guard let token = data?.token else {return}
//            //토큰 저장
//            UserDefaults.standard.set(token, forKey: "token")
//            let savedToken = UserDefaults.standard.object(forKey: "token")
//            print("저장된 토큰 값 \(savedToken!)")
//
//            let tabbarVC = TapbarVC()
//            self.present(tabbarVC, animated: true, completion: nil)
//        }
//    }

    func popUpSocialLogin(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "LoginPopUp")
        self.addChild(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
    }
}
