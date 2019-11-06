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
import SwiftKeychainWrapper
import AdBrixRM

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
    
    lazy var backbutton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(touchUpBackButton))
    
    lazy var gradeDoneButton = UIBarButtonItem(title: "Done",
                                               style: .plain,
                                               target: self,
                                               action: #selector(touchUpGradeDoneButton))
    
    lazy var admissionDoneButton = UIBarButtonItem(title: "Done",
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(touchUpAdmissionDoneButton))
    
    lazy var gradePickerView = UIPickerView()
    var gradePickOption: [String] = []
    
    lazy var admissionPickerView = UIPickerView()
    var admissionPickOption: [String] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var schoolField: SearchTextField!
    
    @IBOutlet weak var majorField: SearchTextField!
    
    @IBOutlet weak var gradeField: UITextField!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    @IBOutlet weak var textFieldsStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = backbutton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAdmissionOption()
        setupDelegate()
        setupLayout()
        
        configureSimpleSearchTextField()
        configureSimpleMajorSearchTextField()
    }
    
    private func setupAdmissionOption() {
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year,
                                                     from: currentDate)
        
        for year in (currentYear - 10...currentYear).reversed() {
            let grade = year % 100
            let gradeString = grade / 10 < 1 ? "0\(grade)학번" : "\(grade)학번"
            gradePickOption.append("\(gradeString)")
        }
    }
    
    private func setupDelegate() {
        schoolField.delegate = self
        majorField.delegate = self
        gradeField.delegate = self
        tapGesture.delegate = self
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        admissionPickerView.delegate = self
        admissionPickerView.dataSource = self
    }
    
    private func setupLayout() {
        
        let flexible
            = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                              target: self,
                              action: nil)
        
        let gradeToolBar = UIToolbar()
        gradeToolBar.barStyle = .default
        gradeToolBar.isTranslucent = true
        gradeToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        gradeToolBar.sizeToFit()
        gradeToolBar.isUserInteractionEnabled = true
        gradeToolBar.setItems([flexible, gradeDoneButton], animated: false)
        gradeDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        let admissionToolBar = UIToolbar()
        admissionToolBar.barStyle = .default
        admissionToolBar.isTranslucent = true
        admissionToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        admissionToolBar.sizeToFit()
        admissionToolBar.isUserInteractionEnabled = true
        admissionToolBar.setItems([flexible, admissionDoneButton], animated: false)
        admissionDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
    
        gradeField.inputView = gradePickerView
        gradeField.inputAccessoryView = gradeToolBar
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchUpGradeDoneButton() {
        view.endEditing(true)
    }
    
    @objc func touchUpAdmissionDoneButton() {
        view.endEditing(true)
    }
    
    private func checkInformation(_ sender: Any) {
        if schoolField.hasText
            && majorField.hasText
            && gradeField.hasText {
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
        
        guard let UUID = KeychainWrapper.standard.string(forKey: "UUID") else {
            return
        }
        
        var major = majorField.text ?? ""
        var univ = schoolField.text ?? ""
        
        //자체 로그인 아닐 시에는
        if sendType != 10 {
            sendData = [
                "userName": name,
                "userNickname": nickName,
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "accessToken": sendToken,
                "userUniv": univ,
                "userMajor": major,
                "userStudentNum": "",
                "userGender": gender,
                "userBirth": birth,
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "userGrade": Int(gradeField.text ?? "") ?? 999,
                "osType": 1,
                "uuid" : UUID
            ]
        } else { //자체로그인일 때는
            let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
            
            sendData = [
                "userEmail": "\(UserInfoVC.emailTextField.text!)", //유저 아이디 //추가
                "userId": "\(UserInfoVC.passwordTextField.text!)", //유저 비밀번호 //추가
                "userName": name,
                "userNickname": nickName,
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "userUniv": univ,
                "userMajor": major,
                "userStudentNum": "2019",
                "userGender": gender,
                "userBirth": birth,
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "userGrade": Int(gradeField.text ?? "") ?? 1,
                "osType": 1,
                "uuid" : UUID
            ]
        }
            
        signupService.requestSingup(sendData) { [weak self] (responseData) in
            guard let response = responseData.value,
                let status = response.status,
                let httpStatus = SingupHttpStatusCode(rawValue: status) else {
                    return
            }
            
            DispatchQueue.main.async {
                switch httpStatus {
                case .success:
                    // 토큰 저장
                    if let storeToken = response.data?.token {
                        KeychainWrapper.standard.set(storeToken,
                                                     forKey: TokenName.token)
                    }
                    
                    UserDefaults.standard.set(false, forKey: "isTryWithoutLogin")
                    
                    guard let token = response.data?.token else {
                        return
                    }
                    
                    let adBrix = AdBrixRM.getInstance
                    
                    // 로그인이 성공했을 때, 유저아이디를 전달
                    adBrix.login(userId: token)
                    
                    //기타 유저 정보
                    var attrModel = Dictionary<String, Any>()
                    attrModel["gender"] = self?.gender
                    attrModel["birth"] = self?.birth
                    attrModel["major"] = major
                    attrModel["univ"] = univ
                    adBrix.setUserProperties(dictionary: attrModel)
                    
                    // 회원가입 이벤트 추가
                    if self?.sendType == 10 {
                        adBrix.commonSignUp(channel: AdBrixRM.AdBrixRmSignUpChannel.AdBrixRmSignUpUserIdChannel)
                    } else {
                        adBrix.commonSignUp(channel: AdBrixRM.AdBrixRmSignUpChannel.AdBrixRmSignUpKakaoChannel)
                    }
                
                    let tapBarVC = TapbarVC()
                    tapBarVC.modalPresentationStyle = .fullScreen
                    self?.present(tapBarVC,
                                  animated: true)
                case .failure:
                    guard let message = response.message else { return }
                    
                    self?.simpleAlert(title: "회원가입 실패",
                                      message: message)
                case .databaseError:
                    self?.simpleAlert(title: "데이터베이스 에러",
                                      message: "서버 오류")
                }
            }
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
    
    @objc func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editingDidBeginMajorField(_ sender: Any) {
        configureSimpleMajorSearchTextField()
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        postData()
    }
    
    @IBAction func touchUpCheckBoxButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "btCheckUnactive"), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "btCheckActive"), for: .normal)
        }
//        checkInformation()
    }
    
    @IBAction func touchUpGradeDropDownButton(_ sender: UIButton) {
        // 선택중이면 return되게 할지 고민해봐야대용
        gradeField.becomeFirstResponder()
    }
}

extension SchoolInfoVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SchoolInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollView.setContentOffset(CGPoint(x: 0, y: textFieldsStackView.frame.origin.y), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        checkInformation(self)
    }
}

extension SchoolInfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return gradePickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return gradePickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        gradeField.text = gradePickOption[row]
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


