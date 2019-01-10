//
//  UserInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 9..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImgae: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isUserInteractionEnabled = false
        
        //        emailTextField.delegate = self
        //        passwordTextField.delegate = self
        //        passwordCheckTextField.delegate = self
        passwordCheckTextField.returnKeyType = .done
        
        
        //        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        //        tapGesture.delegate = self//tapGesturedelgate는 viewcontroller
        //        self.view.addGestureRecognizer(tapGesture)
        iniGestureRecognizer()
        self.titleLabel.isHidden = false
        self.titleImgae.isHidden = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ConfirmProfileVC
        profileVC.id = emailTextField.text ?? ""
        profileVC.password = passwordTextField.text ?? ""
        //        if let destination = segue.destination as? ConfirmProfileVC {
        //            if let id = sender as? String {
        //                destination.ihihih = id(emailTextField.text)
        //
        //            }
        //        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkInformation(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfieldshouldBeginEditing")
        
        return true
    }
    
    @objc func checkInformation(_ sender: Any) {
        print("checkinformation start")
        if (emailTextField.hasText && passwordTextField.hasText && passwordCheckTextField.hasText) {
            print("idfield check / password, confirmpassword, inform check")
            if (passwordTextField.text == passwordCheckTextField.text) {
                print("password correct check")
                nextButton.isUserInteractionEnabled = true
                nextButton.setImage(UIImage(named: "btNextActive"), for: .normal)
            } else {
                nextButton.isUserInteractionEnabled = false
                nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
            }
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textviewshouldbeginediting")
        
        return true
    }
    



    private func textViewDidEndEditing(_ textView: UITextView) {

        print("textViewEndEditing")
        checkInformation(self)
    }
    
    /////////////////////////////////////////////////////
}

extension UserInfoVC : UIGestureRecognizerDelegate {
    
    func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.passwordCheckTextField.resignFirstResponder()
    }
    
    //터치가 먹히는 상황과 안먹히는 상황
    private func gestureRecog(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: emailTextField))! || (touch.view?.isDescendant(of: passwordTextField))! || (touch.view?.isDescendant(of: passwordCheckTextField))! {
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        print(duration)
        print(curve)
        //IOS자체에 애니메이션을 담당해주는 역할. animation을 이용하면 이쁘게 뷰를 꾸밀 수 있다.
        //되게 간단하다.
        //애니메이션 실행 시간 duration , delay는 몇초뒤에 실행할 건지, springwithDamping: 움직일때 떠린다거 나 그런 옵션, initiaon springvelocity -> 가속도 , options ---> curveEaseInOut등등, 을 많이 씀. 이동하거나 크기가 변화 시키는 값을 줄때 curveLinear , completion은 애니매이션이 끝났을때 해주는 것
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
            print("현재 constraint: \(self.stackViewConstraint.constant)")
            self.stackViewConstraint.constant = 10
            self.titleImgae.isHidden = true
            self.titleLabel.isHidden = true
            
        })
        stackViewConstraint.constant = 120
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        //여기서는 weak self를 안쓰는 이유?는?
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.stackViewConstraint.constant = 299
            print(" constraint: \(self.stackViewConstraint.constant)")
            self.titleLabel.isHidden = false
            self.titleImgae.isHidden = false
            
        })
        stackViewConstraint.constant = 299
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
