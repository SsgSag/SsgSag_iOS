//
//  LogoutViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "로그아웃"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpOkButton(_ sender: UIButton) {
        // token 삭제
        UserDefaults.standard.removeObject(forKey: TokenName.token)
        KOSession.shared()?.logoutAndClose(completionHandler: nil)
        
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
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
