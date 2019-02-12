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
        
        if let s = session {
            if s.isOpen() {//세션이 열려있는지 확인
                s.close()
            }
            s.open { (error) in
                if error == nil {
                    if s.isOpen() {
                        print("success")
                    } else {
                        print("fail")
                    }
                } else {
                    print(error!)
                }
            }
        } else {
            print("no session")
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
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
        //        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 5
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
        //        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 6
    func oauth20ConnectionDidFinishDeleteToken() {
        
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
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any] else {return}
            guard let object = result["response"] as? [String: Any] else {return}
            guard let birthday = object["birthday"] as? String else {return}
            guard let name = object["name"] as? String else {return}
            guard let email = object["email"] as? String else {return}
            
            //            self.birthLabel.text = birthday
            //            self.emailLabel.text = email
            //            self.nameLabel.text = name
            
            print(result)
        }
    }
}

