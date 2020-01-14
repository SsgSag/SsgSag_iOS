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
import FBSDKCoreKit

class SchoolInfoVC: UIViewController {
    
    var isSnsLogin: Bool = false
    
    private var gender: String = ""
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
    
    lazy var studentNumberDoneButton = UIBarButtonItem(title: "Done",
                                               style: .plain,
                                               target: self,
                                               action: #selector(touchUpGradeDoneButton))
    
    lazy var gradeDoneButton = UIBarButtonItem(title: "Done",
                                               style: .plain,
                                               target: self,
                                               action: #selector(touchUpGradeDoneButton))
    
    lazy var studentNumberPickerView = UIPickerView()
    var studentNumberPickOption: [String] = []
    
    lazy var gradePickerView = UIPickerView()
    var gradePickOption: [String] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var schoolField: SearchTextField!
    
    @IBOutlet weak var majorField: SearchTextField!
    
    @IBOutlet weak var studentNumberField: UITextField!
    
    @IBOutlet weak var gradeField: UITextField!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var policyCheckBoxButton: UIButton!
    
    @IBOutlet weak var textFieldsStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var servicePolicyButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var nicknameValidateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = backbutton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonUnderline()
        setupAdmissionOption()
        setupDelegate()
        setupLayout()
        
        configureSimpleSearchTextField()
        configureSimpleMajorSearchTextField()
    }
    
    private func setButtonUnderline() {
        let attributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        let servicePolicyAttributedString
            = NSMutableAttributedString(string: servicePolicyButton.titleLabel?.text ?? "",
                                        attributes: attributes)
        
        let privacyPolicyAttributedString
            = NSMutableAttributedString(string: privacyPolicyButton.titleLabel?.text ?? "",
                                        attributes: attributes)
        
        servicePolicyButton.setAttributedTitle(servicePolicyAttributedString,
                                               for: .normal)
        privacyPolicyButton.setAttributedTitle(privacyPolicyAttributedString,
                                               for: .normal)
    }
    
    private func setupAdmissionOption() {
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year,
                                                     from: currentDate)
        
        for year in (currentYear - 10...currentYear).reversed() {
            let studentNumber = year % 100
            
            var studentNumberString
                = studentNumber / 10 < 1 ? "0\(studentNumber)학번" : "\(studentNumber)학번"
            
            if year == currentYear - 10 {
                studentNumberString.insert("~",
                                           at: studentNumberString.startIndex)
            }
            
            studentNumberPickOption.append("\(studentNumberString)")
        }
        
        for grade in 1...5 {
            gradePickOption.append("\(grade)학년")
        }
    }
    
    private func setupDelegate() {
        schoolField.delegate = self
        majorField.delegate = self
        studentNumberField.delegate = self
        gradeField.delegate = self
        nickNameTextField.delegate = self
        birthTextField.delegate = self
        tapGesture.delegate = self
        studentNumberPickerView.delegate = self
        studentNumberPickerView.dataSource = self
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
    }
    
    private func setupLayout() {
        maleButton.isSelected = true
        
        let flexible
            = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                              target: self,
                              action: nil)
        
        let studentNumberToolBar = UIToolbar()
        studentNumberToolBar.barStyle = .default
        studentNumberToolBar.isTranslucent = true
        studentNumberToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        studentNumberToolBar.sizeToFit()
        studentNumberToolBar.isUserInteractionEnabled = true
        studentNumberToolBar.setItems([flexible, studentNumberDoneButton], animated: false)
        studentNumberDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        let gradeToolBar = UIToolbar()
        gradeToolBar.barStyle = .default
        gradeToolBar.isTranslucent = true
        gradeToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        gradeToolBar.sizeToFit()
        gradeToolBar.isUserInteractionEnabled = true
        gradeToolBar.setItems([flexible, gradeDoneButton], animated: false)
        gradeDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
    
        studentNumberField.inputView = studentNumberPickerView
        studentNumberField.inputAccessoryView = studentNumberToolBar

        gradeField.inputView = gradePickerView
        gradeField.inputAccessoryView = gradeToolBar
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchUpGradeDoneButton() {
        view.endEditing(true)
    }
    
    private func checkInformation() {
        guard nicknameValidateLabel.isHidden else {
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return
        }
        
        guard schoolField.hasText
            && majorField.hasText
            && studentNumberField.hasText
            && nickNameTextField.hasText
            && birthTextField.hasText
            && gradeField.hasText else {
                nextButton.isUserInteractionEnabled = false
                
                nextButton.topColor = .lightGray
                nextButton.bottomColor = .lightGray
                return
        }
        
        guard maleButton.isSelected
            || femaleButton.isSelected else {
            nextButton.isUserInteractionEnabled = false

            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray

            return
        }
        
        guard policyCheckBoxButton.isSelected else {
            nextButton.isUserInteractionEnabled = false

            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray

            return
        }
        
        nextButton.isUserInteractionEnabled = true
        
        nextButton.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        nextButton.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
    }
    
    private func validateNickname(_ nickname: String) -> Bool {
        let regEx = "^[a-zA-Z가-힣0-9]{2,10}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: nickname)
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
        
        let major = majorField.text ?? ""
        let univ = schoolField.text ?? ""
        let studentNum: [Character] = (studentNumberField.text ?? "").filter { $0 >= "0" && $0 <= "9" }
        let grade: [Character] = (gradeField.text ?? "").map { $0 }
        
        //자체 로그인 아닐 시에는
        if sendType != 10 {
            sendData = [
                "userNickname": nickNameTextField.text ?? "",
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "accessToken": sendToken,
                "userUniv": univ,
                "userMajor": major,
                "userGrade" : String(grade[0]),
                "userStudentNum": String(studentNum),
                "userGender": gender,
                "userBirth": birthTextField.text ?? "",
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "osType": 1,
                "uuid" : UUID
            ]
        } else { //자체로그인일 때는
            let UserInfoVC = self.navigationController?.viewControllers[0] as! UserInfoVC
            
            sendData = [
                "userEmail": "\(UserInfoVC.emailTextField.text!)", //유저 아이디 //추가
                "userId": "\(UserInfoVC.passwordTextField.text!)", //유저 비밀번호 //추가
                "userNickname": nickNameTextField.text ?? "",
                "signupType": sendType, //0은 카카오톡, 1은 네이버
                "userUniv": univ,
                "userMajor": major,
                "userGrade" : String(grade[0]),
                "userStudentNum": String(studentNum),
                "userGender": gender,
                "userBirth": birthTextField.text ?? "",
                "userPushAllow": 1,
                "userInfoAllow": 1,
                "osType": 1,
                "uuid" : UUID
            ]
        }
            
        signupService.requestSingup(sendData) { [weak self] responseData in
            guard let response = responseData.value,
                let status = response.status,
                let httpStatus = SingupHttpStatusCode(rawValue: status) else {
                    return
            }
            
            DispatchQueue.main.async {
                switch httpStatus {
                case .success:
                    AppEvents.logEvent(AppEvents.Name("EVENT_NAME_COMPELTE_REGISTRATION"))
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
                    attrModel["birth"] = self?.birthTextField.text ?? ""
                    attrModel["major"] = major
                    attrModel["univ"] = univ
                    
                    adBrix.setUserProperties(dictionary: attrModel)
                    
                    // 회원가입 이벤트 추가
                    if self?.sendType == 10 {
                        adBrix.commonSignUp(channel: AdBrixRM.AdBrixRmSignUpChannel.AdBrixRmSignUpUserIdChannel)
                    } else {
                        adBrix.commonSignUp(channel: AdBrixRM.AdBrixRmSignUpChannel.AdBrixRmSignUpKakaoChannel)
                    }
                
                    let tapBarVC = TabBarViewController()
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
        if isSnsLogin {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        
        checkInformation()
    }
    
    @IBAction func touchUpStudentNumberDropDownButton(_ sender: UIButton) {
        // 선택중이면 return되게 할지 고민해봐야대용
        studentNumberField.becomeFirstResponder()
    }
    
    @IBAction func touchUpGradeDropDownButton(_ sender: UIButton) {
        // 선택중이면 return되게 할지 고민해봐야대용
        gradeField.becomeFirstResponder()
    }
    
    @IBAction func touchUpMaleButton(_ sender: UIButton) {
        femaleButton.isSelected = false
        femaleButton.setImage(UIImage(named: "ic_selectAllPassive0"),
                              for: .normal)
        femaleButton.setTitleColor(UIColor(red: 200.0/225.0,
                                           green: 200.0/225.0,
                                           blue: 200.0/225.0,
                                           alpha: 1.0),
                                   for: .normal)
        
        if maleButton.isSelected {
            gender = ""
            maleButton.isSelected = false
            maleButton.setImage(UIImage(named: "ic_selectAllPassive0"),
                                for: .normal)

            maleButton.setTitleColor(UIColor(red: 200.0/225.0,
                                             green: 200.0/225.0,
                                             blue: 200.0/225.0,
                                             alpha: 1.0),
                                     for: .normal)
        } else {
            gender = "male"
            maleButton.isSelected = true
            maleButton.setImage(UIImage(named: "ic_selectAll"),
                                for: .normal)
            maleButton.setTitleColor(UIColor(red: 98.0/225.0,
                                             green: 106.0/225.0,
                                             blue: 225.0/225.0,
                                             alpha: 1.0),
                                     for: .normal)
        }
        checkInformation()
    }
    
    @IBAction func touchUpFemaleButton(_ sender: UIButton) {
        maleButton.isSelected = false
        maleButton.setImage(UIImage(named: "ic_selectAllPassive0"),
                            for: .normal)
        maleButton.setTitleColor(UIColor(red: 200.0/225.0,
                                         green: 200.0/225.0,
                                         blue: 200.0/225.0,
                                         alpha: 1.0),
                                 for: .normal)
        
        if femaleButton.isSelected {
            gender = ""
            femaleButton.isSelected = false
            femaleButton.setImage(UIImage(named: "ic_selectAllPassive0"),
                                  for: .normal)
            
            femaleButton.setTitleColor(UIColor(red: 200.0/225.0,
                                               green: 200.0/225.0,
                                               blue: 200.0/225.0,
                                               alpha: 1.0),
                                     for: .normal)
        } else {
            gender = "female"
            femaleButton.isSelected = true
            femaleButton.setImage(UIImage(named: "ic_selectAll"),
                                  for: .normal)
            
            femaleButton.setTitleColor(UIColor(red: 98.0/225.0,
                                             green: 106.0/225.0,
                                             blue: 225.0/225.0,
                                             alpha: 1.0),
                                     for: .normal)
        }
        
        checkInformation()
    }
    
    @IBAction func touchUpServicePolicyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: StoryBoardName.mypage,
                                      bundle: nil)
        
        guard let termsOfServiceViewController
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.privateProtectViewController)
                as? PrivateProtectViewController else {
                    return
        }
        
        present(termsOfServiceViewController, animated: true)
    }
    
    @IBAction func touchUpPrivacyPolicyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: StoryBoardName.mypage,
        bundle: nil)
        
        guard let privateProtectViewController
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.termsOfServiceViewController)
                as? TermsOfServiceViewController else {
                    return
        }
        
        present(privateProtectViewController, animated: true)
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
        if textField == gradeField && textField.text == "" {
            textField.text = gradePickOption[0]
        }
        
        if textField == studentNumberField && textField.text == "" {
            textField.text = studentNumberPickOption[0]
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollView.setContentOffset(CGPoint(x: 0, y: textFieldsStackView.frame.origin.y), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        checkInformation()
        
        if textField.tag == 1 {
            guard let nickname = textField.text else {
                return
            }
            
            guard validateNickname(nickname) else {
                nicknameValidateLabel.isHidden = false
                nicknameValidateLabel.text = "닉네임은 영어, 한글, 숫자 혼용 2글자 이상으로 입력해주세요"
                return
            }
            
            signupService.requestValidateNickName(nickName: nickname) { [weak self] dataResponse, isValidate in
                switch dataResponse {
                case .success(let status):
                    switch status {
                    case .sucess:
                        if isValidate {
                            DispatchQueue.main.async {
                                self?.nicknameValidateLabel.isHidden = true
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.nicknameValidateLabel.isHidden = false
                                self?.nicknameValidateLabel.text = "이미 사용중인 닉네임입니다."
                            }
                        }
                    case .serverError:
                        DispatchQueue.main.async {
                            self?.simplerAlert(title: "서버 내부 에러")
                        }
                    case .dataBaseError:
                        DispatchQueue.main.async {
                            self?.simplerAlert(title: "데이터베이스 에러")
                        }
                    default:
                        return
                    }
                case .failed(let error):
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
        }
        
    }
}

extension SchoolInfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == gradePickerView {
            return gradePickOption.count
        }
        return studentNumberPickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == gradePickerView {
            return gradePickOption[row]
        }
        return studentNumberPickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == gradePickerView {
            gradeField.text = gradePickOption[row]
            return
        }
        studentNumberField.text = studentNumberPickOption[row]
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


