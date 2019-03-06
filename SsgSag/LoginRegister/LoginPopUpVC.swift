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
        
        if let kakaoSession = session {
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
        } else {
            print("no session")
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    func postData(accessToken: String, loginType: Int) {
        let storyboard = UIStoryboard(name: "SignupStoryBoard", bundle: nil)
        
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupFirst")
        
        let signupNavigator = UINavigationController(rootViewController: signupVC)
        
        let mainVC = TapbarVC()
        
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                print("responseJSON \(responseJSON)")
                if let statusCode = responseJSON["status"] {
                    let status = statusCode as! Int
                    print("statusCode: \(statusCode)")
                    if status == 200 {
                        print("로그인성공")
                        self.present(mainVC, animated: true, completion: nil)
                    } else if status == 404 {
                        print("회원가입필요")
                        self.present(signupNavigator, animated: true, completion: nil)
                    }
                }
            }
            
            do {
                let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data)
                if let token = tokenResponse?.data {
                    UserDefaults.standard.set(token.token, forKey: "SsgSagToken")
                }
            } catch {
                print(error)
            }
        }
    }
}

    func touchUpLoginButton() {
//        guard let email = emailTextField.text else {
//            return ""
//        }
//        guard let password = passwordTextField.text else {
//            return ""
//        }
//        print("5")
//
//        LoginService.shared.login(email: email, password: password) { (data,status) in
//            //            print("this is data token \(data?.token) \(status)")
//            if data?.token == nil {
//                self.emailTextField.text = ""
//                self.passwordTextField.text = ""
//                print("500")
//                if status == 400 {
//                    print("400")
//                    let alertController = UIAlertController(title: "로그인 실패", message: "정확한 ID와 Password를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
//                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    alertController.addAction(action)
//                    self.present(alertController, animated: true, completion: nil)
//                } else if status == 500 {
//                    let alterController = UIAlertController(title: "로그인 실패", message: "서버 내부 에러", preferredStyle: UIAlertController.Style.alert)
//                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    alterController.addAction(action)
//                    self.present(alterController, animated: true, completion: nil)
//                }
//            }
//
//            guard let token = data?.token else {return}
//            //토큰 저장
//            UserDefaults.standard.set(token, forKey: "token")
//            let savedToken = UserDefaults.standard.object(forKey: "token")
//            print("저장된 토큰 값 \(savedToken!)")
//
//            let tabbarVC = TapbarVC()
//            self.present(tabbarVC, animated: true, completion: nil)
//        }
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
            //guard let birthday = object["birthday"] as? String else {return}
            //guard let name = object["name"] as? String else {return}
            //guard let email = object["email"] as? String else {return}
            
            //            self.birthLabel.text = birthday
            //            self.emailLabel.text = email
            //            self.nameLabel.text = name
            
            print(result)
        }
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

