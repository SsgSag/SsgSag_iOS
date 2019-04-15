
//
//  sendDataViewController.swift
//  SsgSag
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin

class SignUpCompleteVC: UIViewController {
    
    let unActiveButtonImages: [String] = [
        "btPreferenceIdeaUnactive",
        "btPreferenceEconomyUnactive",
        "btPreferenceDesignUnactive",
        "btPreferenceLiteratureUnactive",
        "btPreferenceArtUnactive",
        "btPreferenceMarketingUnactive",
        "btPreferenceSocietyUnactive",
        "btPreferenceCameraUnactive",
        "btPreferenceStartupUnactive",
        "btPreferenceHealthUnactive",
        "btPreferenceSholarshipUnactive",
        "btPreferenceTechUnactive"
    ]
    
    let activeButtonImages: [String] = [
        "btPreferenceIdeaActive",
        "btPreferenceEconomyActive",
        "btPreferenceDesignActive",
        "btPreferenceLiteratureActive",
        "btPreferenceArtActive",
        "btPreferenceMarketingActive",
        "btPreferenceSocietyActive",
        "btPreferenceCameraActive",
        "btPreferenceStartupActive",
        "btPreferenceHealthActive",
        "btPreferenceSholarshipActive",
        "btPreferenceTechActive"
    ]
    
    var selectedValues: [Bool] = []
    var sendPreferenceValues: [Int] = []
    
    var name: String = ""
    var birth: String = ""
    var nickName: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""
    var grade: Int = 999
    var number: String = ""
    
    @IBOutlet var preferenceButtons: [UIButton]!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreferenceButtons()
        startButton.isUserInteractionEnabled = false
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackBtn( color: .black)
        setNavigationBar(color: .white)
    }
    
    @IBAction func touchUpPreferenceButtons(_ sender: UIButton) {
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpStartButton(_ sender: Any) {
        checkInterest()
        
        postData()
    }
    
    func setUpPreferenceButtons() {
        var count = 0
        for button in preferenceButtons {
            button.tag = count
            count += 1
        }
        preferenceButtons.forEach { (button) in
            button.isSelected = false
        }
        for _ in 0 ..< count {
            selectedValues.append(false)
        }
    }
    
    func myButtonTapped(myButton: UIButton, tag: Int) {
        if myButton.isSelected {
            myButton.isSelected = false;
            selectedValues[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
        } else {
            myButton.isSelected = true;
            selectedValues[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
        }
        
        if selectedValues.contains(true) {
            startButton.isUserInteractionEnabled = true
            startButton.setImage(UIImage(named: "btSaveMypageActive"), for: .normal)
        } else {
            startButton.isUserInteractionEnabled = false
            startButton.setImage(UIImage(named: "btSaveMypageUnactive"), for: .normal)
        }
    }
    
    func checkInterest() {
        var interest = 0
        for i in selectedValues {
            if i == true {
                print(interest)
                
                sendPreferenceValues.append(interest)
            }
            interest = interest + 1
        }
    }
    
    private func setSendTokenAndSendType(sendToken:inout String, sendType:inout Int) {
        
        if KOSession.shared()?.token != nil {
            guard let sendKakaoToken = KOSession.shared()?.token.accessToken else {
                return
            }
            
            sendToken = sendKakaoToken
            sendType = 0
        } else {
            guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {
                sendType = 10
                
                return
            }
            guard let accessToken = loginConn.accessToken else {
                sendType = 10
                return
            }
            
            sendToken = accessToken
            sendType = 1
        }
        
    }
    
    private func autoLogin(sendType: Int) {
        
        let urlString = UserAPI.sharedInstance.getURL("/login2")
        
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
        
        let sendData: [String: Any] = [
            "userEmail": "\(UserInfoVC.emailTextField.text!)",
            "userId" : "\(UserInfoVC.passwordTextField.text!)",
            "loginType" : sendType //10은 자체 로그인
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: sendData)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
            guard let data = data else {
                return
            }
            
            do {
                let login = try JSONDecoder().decode(LoginStruct.self, from: data)
                
                guard let statusCode = login.status else {return}
                
                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
                
                DispatchQueue.main.async {
                    switch httpStatusCode {
                    case .sucess:
                        
                        if let storeToken = login.data?.token {
                            UserDefaults.standard.set(storeToken,
                                                      forKey: LoginVC.ssgSagToken)
                        }
                        self.present(TapbarVC(), animated: true, completion: nil)
                    case .failure:
                        self.simpleAlert(title: "로그인 실패", message: "")
                    default:
                        break
                    }
                }
            } catch {
                print("LoginStruct Parsing Error")
            }
        }
    }
    
    func postData() {
        
        var sendToken: String = ""
        var sendType: Int = 0
        
        setSendTokenAndSendType(sendToken: &sendToken, sendType: &sendType)
        print("sendType \(sendType)")
        
        var sendData: [String: Any] = [:]
        
        let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
        print("UserInfoVC.emailTextField.text \(UserInfoVC.emailTextField.text)")
        
        //자체 로그인 아닐 시에는
        if sendType != 10 {
            sendData = [
                "userName" : name,
                "userNickname" : nickName,
                "signupType" : sendType, //0은 카카오톡, 1은 네이버
                "accessToken" : sendToken,
                "userUniv" : school,
                "userMajor" : major,
                "userStudentNum" : number,
                "userGender" : gender,
                "userBirth" : birth,
                "userPushAllow" : 1,
                "userInfoAllow" : 1,
                "userInterest" : sendPreferenceValues,
                "userGrade" : grade
            ]
            //자체로그인일 때는
        } else {
            sendData = [
                "userEmail" : "\(UserInfoVC.emailTextField.text!)", //유저 아이디 //추가
                "userId" : "\(UserInfoVC.passwordTextField.text!)", //유저 비밀번호 //추가
                "userName" : name,
                "userNickname" : nickName,
                "signupType" : sendType, //0은 카카오톡, 1은 네이버
                "userUniv" : school,
                "userMajor" : major,
                "userStudentNum" : number,
                "userGender" : gender,
                "userBirth" : birth,
                "userPushAllow" : 1,
                "userInfoAllow" : 1,
                "userInterest" : sendPreferenceValues,
                "userGrade" : grade
            ]
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: sendData)
        
        let urlString = UserAPI.sharedInstance.getURL("/user")
    
        guard let url = URL(string: urlString) else {
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
                
                if let statusCode = responseJSON["status"] {
                    
                    guard let status = statusCode as? Int else {
                        return
                    }
                    
                    guard let httpStatus = HttpStatus(rawValue: status) else {
                        return
                    }
                    
                    switch httpStatus {
                    case .sucess:
                        //바로 로그인 되도록 수정해야한다.
                        self.autoLogin(sendType: sendType)
                        
//                        let loginStoryBoard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
//                        let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "Login")
//                        self.present(loginVC, animated: true, completion: nil)
                    case .databaseError:
                        self.simpleAlert(title: "데이터베이스 에러", message: "서버 오류")
                    case .doNotMatch:
                        self.simpleAlert(title: "잘못된 형식이 포함되었습니다.", message: "회원가입 정보를 정확히 다시 기입해주세요.")
                    }
                }
            }
        }
    }
}

enum HttpStatus:Int {
    case sucess = 201
    case databaseError = 600
    case doNotMatch = 400
}
