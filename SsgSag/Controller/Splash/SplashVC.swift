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

    var nextViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animation = LOTAnimationView(name: "splash")
        
        view.addSubview(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        animation.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        animation.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        animation.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        animation.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        animation.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        if let isAutoLogin = UserDefaults.standard.object(forKey: UserDefaultsName.isAutoLogin) as? Bool {
            if isAutoLogin {
                if isTokenExist() {
                    nextViewController = TapbarVC()
                } else {
                    let loginStoryBoard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
                    let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
                    
                    nextViewController = UINavigationController(rootViewController: loginVC)
                }
            } else {
                let loginStoryBoard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
                let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
                
                nextViewController = UINavigationController(rootViewController: loginVC)
            }
        } else {
            let loginStoryBoard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
            let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
            nextViewController = UINavigationController(rootViewController: loginVC)
        }
        
        animation.play { [weak self] _ in
            guard let self = self else {
                return
            }
            self.present(self.nextViewController, animated: true, completion: nil)
        }
    }
    
    private func isTokenExist() -> Bool {
        if KeychainWrapper.standard.string(forKey: TokenName.token) != nil {
            return true
        } else {
            return false
        }
    }
}

