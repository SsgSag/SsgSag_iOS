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
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
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
            UserDefaults.standard.set(token, forKey: "token")
            
            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
            let swipeVC = storyboard.instantiateViewController(withIdentifier: "Swipe")
            self.present(swipeVC, animated: true, completion: nil)
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
    
    //터치가 먹히는 상황과 안먹히는 상황
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: emailTextField))! || (touch.view?.isDescendant(of: passwordTextField))! {
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        //IOS자체에 애니메이션을 담당해주는 역할. animation을 이용하면 이쁘게 뷰를 꾸밀 수 있다.
        //되게 간단하다.
        //애니메이션 실행 시간 duration , delay는 몇초뒤에 실행할 건지, springwithDamping: 움직일때 떠린다거 나 그런 옵션, initiaon springvelocity -> 가속도 , options ---> curveEaseInOut등등, 을 많이 씀. 이동하거나 크기가 변화 시키는 값을 줄때 curveLinear , completion은 애니매이션이 끝났을때 해주는 것
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
            print("현재 constraint: \(self.stackViewConstraint.constant)")
            self.stackViewConstraint.constant = 30
            print("애니메이션")
        })
//                stackViewConstraint.constant = -120
        
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        //여기서는 weak self를 안쓰는 이유?는?
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.stackViewConstraint.constant = 223
        })
        //stackViewConstraint.constant = 0
        
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
