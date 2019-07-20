//
//  LoginPopUpVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 12/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class LoginPopUpVC: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet var loginBtn: UIButton!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private var snsLoginServiceImp: LoginService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snsLoginServiceImp = LoginServiceImp()
        
        backView.makeRounded(cornerRadius: 4)
    }
    
    @IBAction func naverLogin(_ sender: Any) {
        
        self.simplerAlert(title: "준비중입니다.")
        //        loginInstance?.delegate = self
        //        loginInstance?.requestThirdPartyLogin()
        
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        
        let session = KOSession.shared() //세션 생성
        
        guard let kakaoSession = session else {
            print("no session")
            return
        }
        
        if kakaoSession.isOpen() {//세션이 열려있는지 확인
            kakaoSession.close()
        }
        
        kakaoSession.open { [weak self] (error) in
            if error == nil {
                if kakaoSession.isOpen() {
                    
                    //self.postData(accessToken: kakaoSession.token.accessToken, loginType: 0)
                    
                    self?.snsLoginServiceImp?.requestSnsLogin(using: kakaoSession.token.accessToken, type: 0) { (dataResponse) in
                        
                        if let storeToken = dataResponse.value?.data?.token {
                            UserDefaults.standard.set(storeToken, forKey: TokenName.token)
                        }
                        
                        guard let statusCode = dataResponse.value?.status else {return}
                        
                        DispatchQueue.main.async {
                            switch statusCode {
                            case 200:
                                self?.present(TapbarVC(), animated: true, completion: nil)
                            case 404:
                                let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
                                
                                let signupVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.confirmProfileViewController)
                                
                                let signupNavigator = UINavigationController(rootViewController: signupVC)
                                
                                self?.present(signupNavigator, animated: true, completion: nil)
                            default:
                                break
                            }
                        }
                    }
                } else {
                    print("fail")
                }
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    //MARK: - Naver Login
    // ---- 3
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        if request != nil {
            presentWebViewControllerWithRequest(loginRequest: request)
        } else {
            print("Nil Request")
        }
    }
    
    // ---- 4
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
    }
    
    // ---- 5
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
    }
    
    // ---- 6
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동이 완료되었습니다")
    }
    
    // ---- 7
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error)
    }
    
    // ---- 8
    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        
        let authorization = "\(tokenType) \(accessToken)"
        print(authorization)
        
        snsLoginServiceImp?.requestSnsLogin(using: accessToken, type: 1) { (dataResponse) in
            
            if let storeToken = dataResponse.value?.data?.token {
                UserDefaults.standard.set(storeToken, forKey: TokenName.token)
            }
            
            guard let statusCode = dataResponse.value?.status else {return}
            
            DispatchQueue.main.async {
                switch statusCode {
                case 200:
                    self.present(TapbarVC(), animated: true, completion: nil)
                case 404:
                    let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
                    
                    let signupVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.confirmProfileViewController)
                    
                    let signupNavigator = UINavigationController(rootViewController: signupVC)
                    
                    self.present(signupNavigator, animated: true, completion: nil)
                default:
                    break
                }
            }
        }
    }
    
    //---9
    func requestThirdPartyLogin() {
        let naverLoginConnection: NaverThirdPartyLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLoginConnection.isNaverAppOauthEnable = false
        naverLoginConnection.isInAppOauthEnable = true
        
        naverLoginConnection.consumerKey = kConsumerKey
        naverLoginConnection.consumerSecret = kConsumerSecret
        naverLoginConnection.appName = kServiceAppName
        naverLoginConnection.serviceUrlScheme = kServiceAppUrlScheme
        
        naverLoginConnection.delegate = self
        naverLoginConnection.requestThirdPartyLogin()
    }
    
    func presentWebViewControllerWithRequest(loginRequest: URLRequest) {
        print(loginRequest.description)
        
        let inAppBrowser: NLoginThirdPartyOAuth20InAppBrowserViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: loginRequest)
        self.present(inAppBrowser, animated: true, completion: nil)
    }
}

struct TokenResponse: Codable {
    let status: Int
    let message: String
    let data: SsgSagToken?
}

struct SsgSagToken: Codable {
    let token: String?
}
