//
//  SplashVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 4..
//  Copyright © 2019년 wndzlf. All rights reserved.
//
import UIKit
import Lottie
import SwiftKeychainWrapper

class SplashVC: UIViewController {
    
    private let animation = AnimationView(name: "splash")
    private var nextViewController = UIViewController()
    
    private let loginServiceImp: LoginService
        = DependencyContainer.shared.getDependency(key: .loginService)
    
    private let tapbarServiceImp: TabbarService
        = DependencyContainer.shared.getDependency(key: .tabbarService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isServerAvaliable()
        isAutoLogin()
        setupLayout()
    }
    
    private func setupLayout() {
        
        view.addSubview(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        animation.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        animation.widthAnchor.constraint(
            equalToConstant: view.frame.width).isActive = true
        animation.heightAnchor.constraint(
            equalTo: animation.widthAnchor,
            multiplier: 1.75).isActive = true
    }
    
    private func isAutoLogin() {
            loginServiceImp.requestAutoLogin { [weak self] result in
                switch result {
                case .success(let status):
                    switch status {
                    case .sucess:
                        DispatchQueue.main.async {
                            self?.nextViewController = TapbarVC()
                            
                            self?.animation.play { [weak self] _ in
                                guard let self = self else {
                                    return
                                }

                                self.nextViewController.modalPresentationStyle = .fullScreen
                                self.present(self.nextViewController,
                                             animated: true)
                            }
                        }
                    case .authenticationFailure:
                        let loginStoryBoard = UIStoryboard(name: StoryBoardName.login,
                                                           bundle: nil)
                        
                        DispatchQueue.main.async {
                            let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
                            
                            self?.nextViewController = UINavigationController(rootViewController: loginVC)
                            
                            self?.animation.play { [weak self] _ in
                                guard let self = self else {
                                    return
                                }
                                
                                self.nextViewController.modalPresentationStyle = .fullScreen
                                self.present(self.nextViewController,
                                             animated: true)
                            }
                        }
                    default:
                        return
                    }
                case .failed(let error):
                    print(error)
                    return
                }
                
            }
    }
    
    private func isTokenExist() -> Bool {
        if KeychainWrapper.standard.string(forKey: TokenName.token) != nil {
            return true
        } else {
            return false
        }
    }
    
    // 서버가 유효한지 확인하는 메소드
    private func isServerAvaliable() {
        tapbarServiceImp.requestValidateServer{ [weak self] dataResponse in
            switch dataResponse {
            case .success(let data):
                guard data.data == 0 else {
                    self?.simpleAlertwithHandler(title: "",
                                                 message: "서버 업데이트 중입니다.",
                                                 okHandler: { _ in
                                                    exit(0)
                    })
                    return
                }
            case .failed(let error):
                print(error)
                self?.simpleAlertwithHandler(title: "",
                                             message: "서버 업데이트 중입니다.",
                                             okHandler: { _ in
                                                exit(0)
                })
                return
            }
        }
    }
}

