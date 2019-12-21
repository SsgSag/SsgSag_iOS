//
//  FindPasswordViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 01/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldStackView: UIStackView!
    private let loginService: LoginService
        = DependencyContainer.shared.getDependency(key: .loginService)
    
    lazy var backbutton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = backbutton
        setNavigationBar(color: .white)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpSendEmailButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            simplerAlert(title: "이메일을 입력해주세요")
            return
        }
        
        loginService.requestTempPassword(email: email) { [weak self] result in
            switch result {
            case .success(let statusCode):
                DispatchQueue.main.async {
                    switch statusCode {
                    case .processingSuccess:
                        self?.simpleAlertwithHandler(title: "임시 비밀번호가 발급되었습니다.",
                                                     message: "새로운 비밀번호로 로그인해주세요") { _ in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case .requestError:
                        self?.simplerAlert(title: "유효한 이메일이 아닙니다.")
                    case .dataBaseError:
                        self?.simplerAlert(title: "데이터베이스 에러")
                    case .serverError:
                        self?.simplerAlert(title: "서버 에러")
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
    
}

extension FindPasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if emailTextField.text == "" {
            sendButton.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
            safeAreaView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        } else {
            sendButton.backgroundColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
            safeAreaView.backgroundColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: textFieldStackView.frame.origin.y), animated: true)
    }
}
