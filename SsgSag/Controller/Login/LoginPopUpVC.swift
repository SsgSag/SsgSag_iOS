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

class LoginPopUpVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet var loginBtn: UIButton!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.makeRounded(cornerRadius: 4)
    }
    
    @IBAction func naverLogin(_ sender: Any) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
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
        
        kakaoSession.open { (error) in
            if error == nil {
                if kakaoSession.isOpen() {
                    
                    self.postData(accessToken: kakaoSession.token.accessToken, loginType: 0)
                    
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
    
    func postData(accessToken: String, loginType: Int) {
        let storyboard = UIStoryboard(name: "SignupStoryBoard", bundle: nil)
        
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupFirst")
        
        let signupNavigator = UINavigationController(rootViewController: signupVC)
        
       // let mainVC = TapbarVC()
        
        //0 카톡 로그인, 1은 네이버 로그인(업데이트 예정)
        let json: [String: Any] = [ "accessToken": accessToken,
                                    "loginType" : loginType
            
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = URL(string: "http://52.78.86.179:8080/login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            guard let data = data else {
                return
            }
            
            do {
                let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data)
                
                //토큰 저장시 옵셔널로 저장하면 처음 로그인시 포스터를 제대로 받아오지 못합니다.
                if let storeToken = tokenResponse?.data?.token {
                    UserDefaults.standard.set(storeToken, forKey: "SsgSagToken")
                }
            }
                                                      
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                if let statusCode = responseJSON["status"] {
                    let status = statusCode as! Int
                    
                    if status == 200 {
                        self.present(TapbarVC(), animated: true, completion: nil)
                    } else if status == 404 {
                        self.present(signupNavigator, animated: true, completion: nil)
                    }
                    
                }
            }
        }
    }
    
}

extension LoginPopUpVC: NaverThirdPartyLoginConnectionDelegate {
    // ---- 3
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverSignInViewController, animated: true, completion: nil)
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
        
        self.postData(accessToken: accessToken, loginType: 1)
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
