//
//  SchoolInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import SearchTextField
import NaverThirdPartyLogin

class SchoolInfoVC: UIViewController {
    
    var name: String = ""
    
    var birth: String = ""
    
    var nickName: String = ""
    
    var gender: String = ""
    
    private var sendToken: String = ""
    private var sendType: Int = 0
    
    var jsonResult: [[String: Any]] = [[:]]
    
    private let signupService: SignupService
        = DependencyContainer.shared.getDependency(key: .signUpService)
    
    lazy var tapGesture = UITapGestureRecognizer(target: self,
                                                 action: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var schoolField: SearchTextField!
    
    @IBOutlet weak var majorField: SearchTextField!
    
    @IBOutlet weak var gradeField: UITextField!
    
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupLayout()
        
        configureSimpleSearchTextField()
        configureSimpleMajorSearchTextField()
    }
    
    private func setupDelegate() {
        schoolField.delegate = self
        majorField.delegate = self
        gradeField.delegate = self
        numberField.delegate = self
        tapGesture.delegate = self
    }
    
    private func setupLayout() {
        view.addGestureRecognizer(tapGesture)
    }
    
    private func checkInformation(_ sender: Any) {
        if schoolField.hasText
            && majorField.hasText
            && gradeField.hasText
            && numberField.hasText {
            nextButton.isUserInteractionEnabled = true
            
            nextButton.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
            nextButton.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
            
        } else {
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
        }
    }
    
    private func configureSimpleSearchTextField() {
        schoolField.startVisible = true
        
        let universities = localUniversities()
        schoolField.filterStrings(universities)
    }
    
    private func configureSimpleMajorSearchTextField() {
        majorField.startVisible = true
        
        let majors = localMajors()
        majorField.filterStrings(majors)
    }
    
    private func localUniversities() -> [String] {
        guard let path = Bundle.main.path(forResource: "majorListByUniv",
                                          ofType: "json") else {
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .dataReadingMapped)
            
            guard let jsonResult
                = try JSONSerialization.jsonObject(with: jsonData,
                                                   options: .allowFragments)
                    as? [[String: Any]] else {
                        return []
            }
            
            self.jsonResult = jsonResult
            
            var resultUnivNames: [String] = []
            
            jsonResult.forEach {
                let univName = "\($0["학교명"]!)"
                if !resultUnivNames.contains(univName) {
                    resultUnivNames.append(univName)
                }
            }
            
            return resultUnivNames
        } catch {
            print("Error parsing jSON: \(error)")
            return []
        }
    }
    
    private func localMajors() -> [String] {
        let univName = schoolField.text
        
        for university in jsonResult {
            if univName == "\(university["학교명"]!)" {
                guard let majors = university["학부·과(전공)명"] as? [String] else {
                    return []
                }
                
                return majors
            }
        }
        
        return []
    }
    
    private func postData() {
        setSendTokenAndSendType()
        
        var sendData: [String: Any] = [:]
        
        //자체 로그인 아닐 시에는
        if sendType != 10 {
            
            sendData = [
                "userName": name,
                "userNickname": nickName,
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "accessToken": sendToken,
                "userUniv": schoolField.text ?? "",
                "userMajor": majorField.text ?? "",
                "userStudentNum": numberField.text ?? "",
                "userGender": gender,
                "userBirth": birth,
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "userGrade": Int(gradeField.text ?? "") ?? 999,
                "osType": 1
            ]
        } else { //자체로그인일 때는
            
            let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
            
            sendData = [
                "userEmail": "\(UserInfoVC.emailTextField.text!)", //유저 아이디 //추가
                "userId": "\(UserInfoVC.passwordTextField.text!)", //유저 비밀번호 //추가
                "userName": name,
                "userNickname": nickName,
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "userUniv": schoolField.text ?? "",
                "userMajor": majorField.text ?? "",
                "userStudentNum": numberField.text ?? "2019",
                "userGender": gender,
                "userBirth": birth,
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "userGrade": Int(gradeField.text ?? "") ?? 1,
                "osType": 1
            ]
        }
        
        do {
            let userInfo = try JSONSerialization.data(withJSONObject: sendData)
            
            signupService.requestSingup(userInfo){ [weak self] (responseData) in
                guard let response = responseData.value,
                    let status = response.status,
                    let httpStatus = SingupHttpStatusCode(rawValue: status) else {
                        return
                }
                
                switch httpStatus {
                case .success:
                    // 토큰 저장
                    if let storeToken = response.data?.token {
                        UserDefaults.standard.set(storeToken,
                                                  forKey: TokenName.token)
                    }
                    
                    DispatchQueue.main.async {
                        self?.present(TapbarVC(), animated: true)
                    }
                    
//                    self.autoLogin(sendType: sendType, sendToken: sendToken)
                
                case .failure:
                    guard let message = response.message else { return }
                    
                    self?.simpleAlert(title: "회원가입 실패",
                                      message: message)
                case .databaseError:
                    self?.simpleAlert(title: "데이터베이스 에러",
                                      message: "서버 오류")
                }
            }
        } catch {
            
        }
    }
    
    private func setSendTokenAndSendType() {
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
    
//    private func autoLogin(sendType: Int, sendToken: String) {
//
//        var urlString: URL?
//
//        var sendData: [String: Any] = [:]
//
//        //자체로그인
//        if sendType == 10 {
//            urlString = UserAPI.sharedInstance.getURL("/login2")
//
//            let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
//
//            sendData = [
//                "userEmail": "\(UserInfoVC.emailTextField.text!)",
//                "userId" : "\(UserInfoVC.passwordTextField.text!)",
//                "loginType" : sendType //10은 자체 로그인
//            ]
//        } else {
//
//            urlString = UserAPI.sharedInstance.getURL("/login")
//
//            sendData = [
//                "accessToken": sendToken,
//                "loginType" : sendType //10은 자체 로그인
//            ]
//        }
//
//        guard let url = urlString else { return }
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: sendData)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        NetworkManager.shared.getData(with: request) { (data, err, res) in
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let login = try JSONDecoder().decode(LoginStruct.self, from: data)
//
//                guard let statusCode = login.status else {return}
//
//                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
//
//                DispatchQueue.main.async {
//                    switch httpStatusCode {
//                    case .sucess:
//
//                        if let storeToken = login.data?.token {
//                            UserDefaults.standard.set(storeToken,
//                                                      forKey: TokenName.token)
//                        }
//
//                        self.present(TapbarVC(), animated: true, completion: nil)
//                    case .failure:
//                        self.simpleAlert(title: "로그인 실패", message: "")
//                    default:
//                        break
//                    }
//                }
//            } catch {
//                print("LoginStruct Parsing Error")
//            }
//        }
//    }
    
    @IBAction func editingDidBeginMajorField(_ sender: Any) {
        configureSimpleMajorSearchTextField()
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        postData()
    }
    
}

extension SchoolInfoVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SchoolInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder =  self.view.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInformation(self)
    }
}


enum SingupHttpStatusCode: Int  {
    case success = 201
    case failure = 400
    case databaseError = 600
    
    func findSpecificErrorType(message: String) -> String {
        switch self {
        case .failure:
            return message
        default:
            return "Success Or DatabaseError Type"
        }
    }
}


