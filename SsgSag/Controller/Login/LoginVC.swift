//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AdBrixRM

// 로그인 시작화면
class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var stackViewCenterXConstraint: NSLayoutConstraint!
    
    private let isAutoLogin = "isAutoLogin"
    
    private let loginServiceImp: LoginService
        = DependencyContainer.shared.getDependency(key: .loginService)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIButton()
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        backButton.setImage(UIImage(named: "ic_ArrowBack"), for: .normal)
        backButton.setTitle("처음으로", for: .normal)
        backButton.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(touchUpBackButton), for: .touchUpInside)
        backButton.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setNavigationBar(color: .clear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setAutoLoginButton()
        
        setEmailAndPasswordTextField()
    }
    
    private func setupLayout() {
        
        setShadow(layer: emailTextField.layer)
        setShadow(layer: passwordTextField.layer)
        setShadow(layer: loginButton.layer)
        setShadow(layer: signinButton.layer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        self.stackViewCenterXConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setAutoLoginButton() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsName.isAutoLogin)
    }
    
    private func setShadow(layer: CALayer) {
        layer.masksToBounds = false
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.1
    }
    
    private func setEmailAndPasswordTextField() {
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func ssgSagLogin(_ sender: Any) {
        
        guard let emailText = emailTextField.text,
            let passwordText = passwordTextField.text,
            !emailText.isEmpty && !passwordText.isEmpty else {
            simplerAlert(title: "아이디 또는 비밀번호를\n입력해주세요")
            return
        }
        
        let sendData: [String: Any] = [
            "userEmail": emailText,
            "userId" : passwordText,
            "loginType" : 10 //10은 자체 로그인
        ]
        
        loginServiceImp.requestSelfLogin(send: sendData) { [weak self] (dataResponse) in
            switch dataResponse {
            case .success(let loginData):
                guard let status = loginData.status,
                    let httpStatusCode = HttpStatusCode(rawValue: status) else {
                        return
                }
               
                switch httpStatusCode {
                case .sucess:
                    if let storeToken = loginData.data?.token {
                        KeychainWrapper.standard.set(storeToken,
                                                     forKey: TokenName.token)
                    }
                    
                    UserDefaults.standard.set(false, forKey: "isTryWithoutLogin")
                    
                    guard let token = loginData.data?.token else {
                        return
                    }
                    
                    let adBrix = AdBrixRM.getInstance
                    
                    // 로그인이 성공했을 때, 유저아이디를 전달
                    adBrix.login(userId: token)
                    
                    let tabBar = TapbarVC(nibName: nil, bundle: nil)
                    DispatchQueue.main.async {
                        tabBar.modalPresentationStyle = .fullScreen
                        self?.present(tabBar, animated: true, completion: nil)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "이메일 또는 비밀번호가\n잘못되었습니다.")
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

        signupNavigator.modalPresentationStyle = .fullScreen
        self.present(signupNavigator, animated: true, completion: nil)
    }
    
    @IBAction func touchUpFindPassword(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: StoryBoardName.login,
                                      bundle: nil)
        let findPasswordVC = storyboard.instantiateViewController(withIdentifier: "findPasswordVC")
        navigationController?.pushViewController(findPasswordVC, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.stackViewCenterXConstraint.constant = -(view.frame.height / 6)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.stackViewCenterXConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension LoginVC: UIGestureRecognizerDelegate {
}
