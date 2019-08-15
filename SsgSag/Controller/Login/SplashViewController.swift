//
//  SplashViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 31/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SplashViewController: UIViewController {

    private let loginServiceImp: LoginService
        = DependencyContainer.shared.getDependency(key: .loginService)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpLookAroundButton(_ sender: UIButton) {
    }
    
    @IBAction func touchUpSelfLoginButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: StoryBoardName.login,
                                      bundle: nil)
        let selfLoginVC
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.loginViewController)
        
        navigationController?.pushViewController(selfLoginVC, animated: true)
    }
    
    @IBAction func touchUpKakaoLoginButton(_ sender: UIButton) {
        
        let session = KOSession.shared() //세션 생성
        
        guard let kakaoSession = session else {
            print("no session")
            return
        }
        
        if kakaoSession.isOpen() {//세션이 인증되어있는지 확인
            kakaoSession.close()
        }
        
        kakaoSession.open { [weak self] (error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if kakaoSession.isOpen() {
                
                //self.postData(accessToken: kakaoSession.token.accessToken, loginType: 0)
                
                self?.loginServiceImp.requestSnsLogin(
                    using: kakaoSession.token.accessToken,
                    type: 0
                ) { [weak self] (dataResponse) in
                    switch dataResponse {
                    case .success(let response):
                        if let storeToken = response.data?.token {
                            KeychainWrapper.standard.set(storeToken, forKey: TokenName.token)
                        }
                        
                        DispatchQueue.main.async {
                            switch response.status {
                            case 200:
                                self?.present(TapbarVC(), animated: true, completion: nil)
                            case 404:
                                let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
                                
                                let signupVC = storyboard.instantiateViewController(withIdentifier: "ConfirmProfileVC")
                                
                                let signupNavigator = UINavigationController(rootViewController: signupVC)
                                
                                self?.present(signupNavigator, animated: true, completion: nil)
                            default:
                                break
                            }
                        }
                    case .failed(let error):
                        print(error)
                        return
                    }
                }
            } else {
                print("fail")
            }
        }
    }
}
