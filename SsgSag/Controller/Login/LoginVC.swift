//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

// 로그인 시작화면
class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var autoLoginButton: UIButton!
    
    private let isAutoLogin = "isAutoLogin"
    
    var loginServiceImp:LoginService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setService()
        
        setAutoLoginButton()
        
        setEmailAndPasswordTextField()
    }
    
    func setService(_ loginService: LoginService = LoginServiceImp() ){
        self.loginServiceImp = loginService
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setAutoLoginButton() {
        
        guard let isAuto = UserDefaults.standard.object(forKey: UserDefaultsName.isAutoLogin) as? Bool else {
            
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.isAutoLogin)
            
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
            UserDefaults.standard.set(false, forKey: UserDefaultsName.isAutoLogin)
        } else {
            autoLoginButton.setImage(UIImage(named: "checkboxRoundActive"), for: .normal)
            UserDefaults.standard.set(true, forKey: UserDefaultsName.isAutoLogin)
        }
    }
    
    @IBAction func ssgSagLogin(_ sender: Any) {
        
        let sendData: [String: Any] = [
            "userEmail": emailTextField.text!,
            "userId" : passwordTextField.text!,
            "loginType" : 10 //10은 자체 로그인
        ]
        
        loginServiceImp.requestLogin(send: sendData) { (dataResponse) in
            
            guard let statusCode = dataResponse.value?.status else {return}
            
            guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
            
            DispatchQueue.main.async {
                switch httpStatusCode {
                case .sucess:
                    if let storeToken = dataResponse.value?.data?.token {
                        UserDefaults.standard.set(storeToken,
                                                  forKey: TokenName.token)
                    }
                    self.present(TapbarVC(), animated: true, completion: nil)
                case .failure:
                    self.simpleAlert(title: "로그인 실패", message: "")
                default:
                    break
                }
            }
        }
        
    }
    
    @IBAction func ssgSagSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        let ConfirmProfileVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.confirmProfileVC)
        let signupNavigator = UINavigationController(rootViewController: ConfirmProfileVC)
        self.present(signupNavigator, animated: true, completion: nil)
    }
    
    func popUpSocialLogin(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.loginPopUpViewController)
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



enum HttpStatusCode: Int, Error {
    
    case sucess = 200
    case secondSucess = 201
    case favoriteSuccess = 204
    case failure = 404
    case dataBaseError = 600
    case serverError = 500
    
    func throwError() throws {
        switch self {
        case .failure:
            throw HttpStatusCode.failure
        case .dataBaseError:
            throw HttpStatusCode.dataBaseError
        case .serverError:
            throw HttpStatusCode.serverError
        default:
            break
        }
    }
    
}

struct LoginStruct: Codable {
    let status: Int?
    let message: String?
    let data: login?
}

struct login: Codable {
    let token: String?
}
