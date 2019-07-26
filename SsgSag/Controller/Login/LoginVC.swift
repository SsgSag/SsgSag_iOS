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
        UserDefaults.standard.setValue(true, forKey: UserDefaultsName.isAutoLogin)
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
        
        loginServiceImp.requestLogin(send: sendData) { [weak self] (dataResponse) in
            switch dataResponse {
            case .success(let loginData):
                guard let status = loginData.status,
                    let httpStatusCode = HttpStatusCode(rawValue: status) else {
                        return
                }
                
                switch httpStatusCode {
                case .sucess:
                    if let storeToken = loginData.data?.token {
                        UserDefaults.standard.set(storeToken,
                                                  forKey: TokenName.token)
                    }
                    
                    DispatchQueue.main.async {
                        self?.present(TapbarVC(), animated: true, completion: nil)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "로그인 실패")
                    }
                default:
                    break
                }
            case .failed(let error):
                print(error)
                return
            }
        }
        
    }
    
    @IBAction func ssgSagSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        let userInfoVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.userInfoViewContrller)
        let signupNavigator = UINavigationController(rootViewController: userInfoVC)
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
    case processingSuccess = 204
    case authenticationFailure = 401
    case authorizationFailure = 403
    case failure = 404
    case dataBaseError = 600
    case serverError = 500
    
    func throwError() throws {
        switch self {
        case .authorizationFailure:
            throw HttpStatusCode.authorizationFailure
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
