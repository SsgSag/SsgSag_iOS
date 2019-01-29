//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var loginBtn: UIButton!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniGestureRecognizer()
        let color1 = UIColor.rgb(red: 155, green: 65, blue: 250)
        let color2 = UIColor.rgb(red: 35, green: 191, blue: 251)
        let color3 = UIColor.rgb(red: 60, green: 234, blue: 252)
        view.setGradientBackGround(colorOne: color1, colorTwo: color2, colorThree: color3)
//        let backgroundView = UIView()
//
//        view.addSubview(backgroundView)
//        backgroundView.setGradient(from: .blue, to: .red)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.bounds = view.bounds
    
    }
    
    @IBAction func naverLogin(_ sender: Any) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        let session = KOSession.shared() //세션 생성
        
        if let s = session {
            if s.isOpen() {//세션이 열려있는지 확인
                s.close()
            }
            s.open { (error) in
                if error == nil {
                    if s.isOpen() {
                        print("success")
                    } else {
                        print("fail")
                    }
                } else {
                    print(error!)
                }
            }
        } else {
            print("no session")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
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
    
    @IBAction func touchUpLoginButton(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        print("5")
        
        LoginService.shared.login(email: email, password: password) { (data,status) in
            //            print("this is data token \(data?.token) \(status)")
            if data?.token == nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                print("500")
                if status == 400 {
                    print("400")
                    let alertController = UIAlertController(title: "로그인 실패", message: "정확한 ID와 Password를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                } else if status == 500 {
                    let alterController = UIAlertController(title: "로그인 실패", message: "서버 내부 에러", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alterController.addAction(action)
                    self.present(alterController, animated: true, completion: nil)
                }
            }
            
            guard let token = data?.token else {return}
            //토큰 저장
            UserDefaults.standard.set(token, forKey: "token")
            let savedToken = UserDefaults.standard.object(forKey: "token")
            print("저장된 토큰 값 \(savedToken!)")
            
            let tabbarVC = TapbarVC()
            self.present(tabbarVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func touchUpSignupButton(_ sender: Any) {
        
    }
    
}

extension LoginVC : UIGestureRecognizerDelegate {
    
    func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: emailTextField))! || (touch.view?.isDescendant(of: passwordTextField))! {
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
//            print("현재 constraint: \(self.stackViewConstraint.constant)")
//            self.stackViewConstraint.constant = 30
        })
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
//            self.stackViewConstraint.constant = 223
        })
        
        self.view.layoutIfNeeded()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension LoginVC: NaverThirdPartyLoginConnectionDelegate{
    // ---- 3
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverSignInViewController, animated: true, completion: nil)
    }
    // ---- 4
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
//        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 5
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
//        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 6
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    // ---- 7
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error)
    }
    // ---- 8
    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        
        let authorization = "\(tokenType) \(accessToken)"
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any] else {return}
            guard let object = result["response"] as? [String: Any] else {return}
            guard let birthday = object["birthday"] as? String else {return}
            guard let name = object["name"] as? String else {return}
            guard let email = object["email"] as? String else {return}
            
//            self.birthLabel.text = birthday
//            self.emailLabel.text = email
//            self.nameLabel.text = name
            print(result)
        }
    }
}
