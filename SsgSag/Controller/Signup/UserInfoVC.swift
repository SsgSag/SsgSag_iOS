//
//  UserInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 9..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var isInvaliedEmailLabel: UILabel!
    
    @IBOutlet weak var isnotEqualPWLabel: UILabel!
    
    private let signUpServiceImp: SignupService
        = DependencyContainer.shared.getDependency(key: .signUpService)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordCheckTextField.returnKeyType = .done
        
        iniGestureRecognizer()
        
        setDelegate()
        
        setViewWithTag()
    }
    
    private func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
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
    
    // validate an email for the right format
    private func isValidEmail(email: String?) -> Bool {
        
        guard email != nil else {
            return false
        }
        
        let regEx = """
        ^[0-9a-zA-Z][0-9a-zA-Z\\_\\-\\.\\+]+[0-9a-zA-Z]@[0-9a-zA-Z][0-9a-zA-Z\\_\\-]*[0-9a-zA-Z](\\.[a-zA-Z]{2,6}){1,2}$
        """
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: email)
    }
    
    private func isValidatePassword(password: String?) -> Bool {
        guard password != nil else {
            return false
        }
        
        let regEx = "^[a-zA-Z0-9!@#$%^&*]{8,20}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: password)
    }
    
    @IBAction func touchUpValidButton(_ sender: UIButton) {
        guard isValidEmail(email: emailTextField.text) else {
            isInvaliedEmailLabel.textColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
            isInvaliedEmailLabel.text = "이메일 형식이 아닙니다"
            return
        }
        
        guard let userEmailString = emailTextField.text else {
            return
        }
        
        let urlString = "/user/validateEmail?userEmail=\(userEmailString)"
    
        signUpServiceImp.requestValidateEmail(urlString: urlString) { [weak self] dataResponse, isValidate in
            switch dataResponse {
            case .success(let status):
                switch status {
                case .sucess:
                    if isValidate {
                        DispatchQueue.main.async {
                            self?.isInvaliedEmailLabel.textColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
                            self?.isInvaliedEmailLabel.text = "사용가능한 이메일입니다"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.isInvaliedEmailLabel.textColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
                            self?.isInvaliedEmailLabel.text = "이미 존재하는 이메일입니다"
                        }
                    }
                case .dataBaseError, .serverError:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "서버 내부 에러")
                    }
                default:
                    return
                }
            case .failed(let error):
                assertionFailure(error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func touchUpBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmEmail(_ sender: Any) {
        guard checkInformation() else { return }
        
        let storyboard = UIStoryboard(name: StoryBoardName.signup,
                                      bundle: nil)
        
        let ConfirmProfileVC
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.confirmProfileViewController)
                as! ConfirmProfileVC
        
        navigationController?.pushViewController(ConfirmProfileVC,
                                                 animated: true)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordCheckTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration
            = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                as? Double,
            let curve
            = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
                as? UInt else {
                    return
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0.3,
                       options: .init(rawValue: curve),
                       animations: { [weak self] in
                        guard let height = self?.view.frame.height else { return }
                        self?.stackViewConstraint.constant = -(height / 10)
        })
        
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration
            = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                as? Double,
            let curve
            = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
                as? UInt else {
                    return
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0.3,
                       options: .init(rawValue: curve),
                       animations: { [weak self] in
                        self?.stackViewConstraint.constant = 0
        })
        
        view.layoutIfNeeded()
    }
    
    func checkInformation() -> Bool {
        
        guard emailTextField.hasText
            && passwordTextField.hasText
            && passwordCheckTextField.hasText else {
            
            simplerAlert(title: "기입되지 않은 사항이 있습니다.")
            nextButton.isUserInteractionEnabled = false
                
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return false
        }
        
        guard isValidatePassword(password: passwordTextField.text) else {
            simplerAlert(title: "비밀번호 형식이 잘못되었습니다.\n(영문자, 숫자, 특수문자(!@#$%^&*)를 사용한 8~20자)")
            
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return false
        }
        
        guard passwordTextField.text == passwordCheckTextField.text else {
            
            self.simplerAlert(title: "두개의 패스워드가 다릅니다.")
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            
            return false
        }
        
        return true
    }
}

extension UserInfoVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UserInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard passwordTextField.text == passwordCheckTextField.text else {
            isnotEqualPWLabel.isHidden = false
            return
        }
        
        isnotEqualPWLabel.isHidden = true
        
        guard emailTextField.hasText
            && passwordTextField.hasText
            && passwordCheckTextField.hasText else {
                return
        }
        
        guard isInvaliedEmailLabel.text == "사용가능한 이메일입니다" else {
            return
        }
        
        nextButton.isUserInteractionEnabled = true
        
        nextButton.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        nextButton.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
    }
}

