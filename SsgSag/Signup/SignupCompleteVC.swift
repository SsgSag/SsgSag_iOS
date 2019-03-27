
//
//  sendDataViewController.swift
//  SsgSag
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

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
        print(sender.tag)
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
    
    func postData() {
        guard let sendToken = KOSession.shared()?.token.accessToken else {
            return
        }
        
        let sendData: [String: Any] = [
            "userName" : name,
            "userNickname" : nickName,
            "signupType" : 0, //0은 카카오톡, 1은 네이버
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
        
        /*
        print(" userName : \(name), userNickname : \(nickName), signupType : 0, //0은 카카오톡, 1은 네이버 accessToken : \(sendToken),userUniv : \(school),userMajor : \(major),userStudentNum : \(number), userGender : \(gender), userBirth : \(birth), userPushAllow : 1, userInfoAllow : 1, userInterest : \(sendPreferenceValues), userGrade : \(grade)")
        */
        
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
                        let loginStoryBoard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
                        let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "Login")
                        self.present(loginVC, animated: true, completion: nil)
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


/*
 {
 "userName" : "김현수",
 "userNickname" : "김현슨",
 "signupType" : 0, //0은 카카오톡, 1은 네이버
 "accessToken" : "9_JkQE5SPfD0k1SbplKR2cU39g-l2MfOofz2lgoqAuYAAAFosk3w-w",
 "userUniv" : "인하대학교",
 "userMajor" :"컴퓨터공학과",
 "userStudentNum" :"12141523",
 "userGender" :"male",
 "userBirth" :"951107",
 "userPushAllow" : 1,
 "userInfoAllow" : 1,
 "userInterest" : [0, 1, 2, 3, 4, 5,  6, 7, 8, 9, 10, 11],
 "userGrade" : 4
 }
 */
