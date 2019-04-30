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
        
        passwordCheckTextField.returnKeyType = .done
        
        iniGestureRecognizer()
        
        setDelegate()
        
        setViewWithTag()
        
        self.titleLabel.isHidden = false
        
        self.titleImgae.isHidden = false
    }
    
    private func setDelegate() {
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
        
        passwordCheckTextField.delegate = self
    }
    
    private func setViewWithTag() {
        emailTextField.tag = 1
        passwordTextField.tag = 2
        passwordCheckTextField.tag = 3
    }
    
    @IBAction func nextActionButton(_ sender: Any) {
        //여기서 중복 확인을 하자.
        
        guard let userEmailString = emailTextField.text else { return }
        
        let signupType:Int = 10 //자체 로그인은 10
        
        guard let url = UserAPI.sharedInstance.getURL("/user/validate?userEmail=\(userEmailString)&signupType=\(signupType)") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let isDuplicateNetworkModel = try JSONDecoder().decode(EmailDuplicate.self, from: data)
                
                guard let httpStatusCode = isDuplicateNetworkModel.status else {return}
                
                guard let status = HttpStatusCode(rawValue: httpStatusCode) else {return}
                
                switch status {
                case .sucess:
                    guard let isDuplicated = isDuplicateNetworkModel.data else {return}
                    
                    DispatchQueue.main.async {
                        if isDuplicated {
                            let storyboard = UIStoryboard(name: "SignupStoryBoard", bundle: nil)
                            let SchoolInfoVC = storyboard.instantiateViewController(withIdentifier: "SignupFirst") as! ConfirmProfileVC
                            self.navigationController?.pushViewController(SchoolInfoVC, animated: true)
                        } else {
                            self.simplerAlert(title: "중복되는 이메일이 존재합니다.")
                        }
                    }
                    
                case .dataBaseError, .serverError:
                    self.simplerAlert(title: "서버 내부 에러")
                default:
                    break
                }
            } catch {
                print("Email Duplicate Parsing Error")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextTag){
            
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func touchUpBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkInformation(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        checkInformation(self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInformation(self)
    }
    
    @objc func checkInformation(_ sender: Any) {
        if (emailTextField.hasText && passwordTextField.hasText && passwordCheckTextField.hasText) {
            print("idfield check / password, confirmpassword, inform check")
            if (passwordTextField.text == passwordCheckTextField.text) {
                print("password correct check")
                nextButton.isUserInteractionEnabled = true
                nextButton.setImage(UIImage(named: "btNextActive"), for: .normal)
            } else {
                nextButton.isUserInteractionEnabled = false
                nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
                
                self.simplerAlert(title: "두개의 패스워드가 다릅니다.")
                passwordTextField.text = ""
                passwordCheckTextField.text = ""
            }
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
        }
    }
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
    
    private func gestureRecog(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: emailTextField))! || (touch.view?.isDescendant(of: passwordTextField))! || (touch.view?.isDescendant(of: passwordCheckTextField))! {
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.3, options: .init(rawValue: curve), animations: { [unowned self] in
            self.stackViewConstraint.constant = 120
            self.titleImgae.isHidden = true
            self.titleLabel.isHidden = true
        })
        
        stackViewConstraint.constant = 120
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        UIView.animate(withDuration: duration, delay: 0.3, options: .init(rawValue: curve), animations: {
            
            self.stackViewConstraint.constant = 299
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

struct EmailDuplicate: Codable {
    let status: Int?
    let message: String?
    let data: Bool?
}
