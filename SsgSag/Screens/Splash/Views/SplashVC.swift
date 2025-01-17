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
    static var isLatest: Bool = true
    
    private let animation = AnimationView(name: "splash")
    
    private let loginServiceImp: LoginService
        = DependencyContainer.shared.getDependency(key: .loginService)
    
    private let tapbarServiceImp: TabbarService
        = DependencyContainer.shared.getDependency(key: .tabbarService)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        animation.play { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if self.isUpdateAvailable() {
                self.showNeedForUpdate()
            } else {
                self.notUpdate(isLatest: true)
            }
        }
    }
    
    private func showNeedForUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.simpleAlertWithHandlers(title: "업데이트",
                                          message: "최신 업데이트가 있습니다.\n업데이트하시겠습니까?",
                                          okHandler: { _ in
                                            self?.moveToAppStore()
            },
                                          cancelHandler: { _ in
                                            self?.notUpdate(isLatest: false)
            })
        }
    }
    
    private func moveToAppStore() {
        let urlString = "https://itunes.apple.com/app/id1457422029"
        UIApplication.shared.open(URL(string: urlString)!)
    }
    
    private func notUpdate(isLatest: Bool) {
        SplashVC.isLatest = isLatest
        self.isServerAvaliable()
        self.isAutoLogin(isLatest: isLatest)
    }
    
    private func isUpdateAvailable() -> Bool {
        guard let version
            = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url
            = URL(string: "http://itunes.apple.com/lookup?bundleId=com.wndzlf.SsgSag"),
            let data
            = try? Data(contentsOf: url),
            let json
            = try? JSONSerialization.jsonObject(with: data,
                                                options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String else {
                return false
        }

        if version < appStoreVersion {
            return true
        }

        return false
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
    
    private func isAutoLogin(isLatest: Bool) {
            loginServiceImp.requestAutoLogin { [weak self] result in
                switch result {
                case .success(let status):
                    switch status {
                    case .sucess:
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(false, forKey: "isTryWithoutLogin")
                            let tabBarVC = TabBarViewController()
                            
                            tabBarVC.modalPresentationStyle = .fullScreen
                            self?.present(tabBarVC,
                                          animated: true)
                        }
                    case .authenticationFailure, .serverError:
                        let loginStoryBoard = UIStoryboard(name: StoryBoardName.login,
                                                           bundle: nil)
                        AppDelegate.posterIndex = nil
                        
                        DispatchQueue.main.async {
                            
                            let introStoryBoard = UIStoryboard(name: "IntroStoryboard",
                                                                bundle: nil)
                            
                            guard let introViewController
                                = introStoryBoard.instantiateViewController(withIdentifier: "IntroPageViewController") as? IntroPageViewController else { return }
                            
                            let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
                            
                            let nextViewController = UINavigationController(rootViewController: introViewController)

                            nextViewController.modalPresentationStyle = .fullScreen
                            self?.present(nextViewController,
                                          animated: true)
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
        guard let version
            = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return
        }
        
        tapbarServiceImp.requestValidateServer(version: version) { [weak self] dataResponse in
            DispatchQueue.main.async {
                switch dataResponse {
                case .success(let data):
                    guard data.data == 0 || data.data == 1 else {
                        self?.simpleAlertwithOKButton(title: "",
                                                      message: "서버 점검 중입니다.",
                                                      okHandler: { _ in
                                                            exit(0)
                        })
                        return
                    }
                case .failed(let error):
                    print(error)
                    self?.simpleAlertwithOKButton(title: "",
                                                 message: "서버 점검 중입니다.",
                                                 okHandler: { _ in
                                                    exit(0)
                    })
                    return
                }
            }
        }
    }
}

