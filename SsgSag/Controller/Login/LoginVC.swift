//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var autoLoginButton: UIButton!
    
    static let ssgSagToken = "SsgSagToken"
    
    private let isAutoLogin = "isAutoLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAutoLoginButton()
        setEmailAndPasswordTextField()
        //setGesture()
    }
    
//    private func setGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self.view, action: selector("endEditing:"))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc private func endEditing() {
//        textfieldend
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setAutoLoginButton() {
        
        guard let isAuto = UserDefaults.standard.object(forKey: "isAutoLogin") as? Bool else {
            
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            
            UserDefaults.standard.setValue(true, forKey: "isAutoLogin")
            
            return
        }
    
        if isAuto {
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
        } else {
            autoLoginButton.setImage(UIImage(named: "checkboxRound"), for: .normal)
        }
        
    }
    
    private func setEmailAndPasswordTextField() {
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        popUpSocialLogin(button: sender)
    }
    
    @IBAction func touchUpAutoLoginButton(_ sender: UIButton) {
        
        guard let autoLoginButtonImage = autoLoginButton.imageView?.image else {
            return
        }
        
        if autoLoginButtonImage == UIImage(named: "checkboxRoundActive") {
            autoLoginButton.setImage(UIImage(named:"checkboxRound"), for: .normal)
            UserDefaults.standard.set(false, forKey: "isAutoLogin")
        } else {
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            UserDefaults.standard.set(true, forKey: "isAutoLogin")
        }
    }
    
    @IBAction func ssgSagLogin(_ sender: Any) {
        let urlString = UserAPI.sharedInstance.getURL("/login2")
        
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        let sendData: [String: Any] = [
            "userEmail": emailTextField.text!,
            "userId" : passwordTextField.text!,
            "loginType" : 10 //10은 자체 로그인
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: sendData)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        NetworkManager.shared.getData(with: request) { (data, err, res) in
            guard let data = data else {
                return
            }
            
            do {
                let login = try JSONDecoder().decode(LoginStruct.self, from: data)
                
                guard let statusCode = login.status else {return}
                
                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
            
                DispatchQueue.main.async {
                    switch httpStatusCode {
                    case .sucess:
                        
                        if let storeToken = login.data?.token {
                            UserDefaults.standard.set(storeToken,
                                                      forKey: LoginVC.ssgSagToken)
                        }
                        
                        self.present(TapbarVC(), animated: true, completion: nil)
                    case .failure:
                        self.simpleAlert(title: "로그인 실패", message: "")
                    default:
                        break
                    }
                }
            } catch {
                print("LoginStruct Parsing Error")
            }
        }
    }
    
    @IBAction func ssgSagSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignupStoryBoard", bundle: nil)
        let UserInfoVC = storyboard.instantiateViewController(withIdentifier: "UserInfoVC")
        let signupNavigator = UINavigationController(rootViewController: UserInfoVC)
        self.present(signupNavigator, animated: true, completion: nil)
    }
    
    func popUpSocialLogin(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "LoginPopUp")
        self.addChild(popVC)
        
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}


enum HttpStatusCode: Int {
    case sucess = 200
    case failure = 404
    case dataBaseError = 600
    case serverError = 500
}

struct LoginStruct: Codable {
    let status: Int?
    let message: String?
    let data: login?
}

struct login: Codable {
    let token: String?
}
