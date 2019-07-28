//
//  MembershipCancelViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class MembershipCancelViewController: UIViewController {

    private let myPageServiceImp: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpCancelButton(_:)))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "회원탈퇴"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func requestMembershipCancel() {
        
        myPageServiceImp.requestMembershipCancel() { [weak self] response in
            switch response {
            case .success(let status):
                DispatchQueue.main.async {
                    switch status {
                    case .processingSuccess:
                        self?.simpleAlertwithHandler(title: "",
                                                     message: "회원 탈퇴가 완료되었습니다.") { _ in
                            self?.moveToLoginViewController()
                        }
                    case .authorizationFailure:
                        self?.simplerAlert(title: "인가 실패")
                    case .failure:
                        self?.simplerAlert(title: "회원을 찾을 수 없습니다.")
                    case .authenticationFailure:
                        self?.simplerAlert(title: "인증 실패")
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
    
    private func moveToLoginViewController() {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginVC
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
        viewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
    
    @IBAction func touchUpMembershipCancelButton(_ sender: UIButton) {
        requestMembershipCancel()
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
