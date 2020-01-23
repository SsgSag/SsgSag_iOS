//
//  LogoutViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
//import AdBrixRM

class LogoutViewController: UIViewController {

    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpCancelButton(_:)))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "로그아웃"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpOkButton(_ sender: UIButton) {
//        let adBrix = AdBrixRM.getInstance
        
        if KOSession.shared()?.token != nil {
            guard let kakaoToken = KOSession.shared()?.token.accessToken else {
                return
            }
//            adBrix.login(userId: kakaoToken)
        }
        
//        if let token = KeychainWrapper.standard.object(forKey: TokenName.token) as? String {
//            adBrix.login(userId: token)
//        }
    
        // token 삭제
        KeychainWrapper.standard.removeObject(forKey: TokenName.token)
        KOSession.shared()?.logoutAndClose(completionHandler: nil)
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
        
        let rootNavigationController = UINavigationController(rootViewController: viewController)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootNavigationController
        
        rootNavigationController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = rootNavigationController
        }, completion: nil)
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
