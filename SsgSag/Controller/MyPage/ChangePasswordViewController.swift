//
//  ChangePasswordViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 11/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    @IBOutlet weak var isEqualPasswordLabel: UILabel!
    
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let mypageService: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.title = "비밀번호 변경"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func isValidatePassword(password: String?) -> Bool {
        guard password != nil else {
            return false
        }
        
        let regEx = "^[a-zA-Z0-9!@#$%^&*]{8,20}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: password)
    }
    
    @IBAction func touchUpCompleteButton(_ sender: UIButton) {
        guard currentPasswordTextField.hasText
            && newPasswordTextField.hasText
            && checkPasswordTextField.hasText else {
                simplerAlert(title: "모든 정보를 입력해주세요")
                return
        }
        
        guard isValidatePassword(password: newPasswordTextField.text) else {
            simplerAlert(title: "비밀번호 형식이 잘못되었습니다.\n(영문자, 숫자, 특수문자(!@#$%^&*)를 사용한 8~20자)")
            return
        }
        
        guard newPasswordTextField.text == checkPasswordTextField.text else {
            simplerAlert(title: "새로운 비밀번호와 확인 비밀번호가 일치하지 않습니다.")
            return
        }
        
        // 비밀번호 형식 확인
        guard let oldPassword = currentPasswordTextField.text,
            let newPassword = newPasswordTextField.text else {
                return
        }
        
        mypageService.requestChangePassword(oldPassword: oldPassword,
                                            newPassword: newPassword) { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    switch status {
                    case .processingSuccess:
                        self?.simpleAlertwithOKButton(title: "", message: "새로운 비밀번호로 변경되었습니다.", okHandler: { _ in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    case .requestError:
                        self?.simplerAlert(title: "기존 비밀번호가 잘못되었습니다.")
                        return
                    case .dataBaseError:
                        self?.simplerAlert(title: "datebase error")
                        return
                    case .serverError:
                        self?.simplerAlert(title: "server error")
                        return
                    default:
                        return
                    }
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if newPasswordTextField.text == checkPasswordTextField.text {
            isEqualPasswordLabel.isHidden = true
        } else {
            isEqualPasswordLabel.isHidden = false
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textFieldStackView.frame.origin.y), animated: true)
    }
}

extension ChangePasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return true
    }
}
