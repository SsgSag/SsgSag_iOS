
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
    
    var id: String = ""
    var password: String = ""
    var name: String = ""
    var birth: String = ""
    var nickName: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""
    var grade: String = ""
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
        
        let tabbarVC = TapbarVC()
        self.present(tabbarVC, animated: false, completion: nil)
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
        for i in selectedValues {
            var interest = 0
            if i == true {
                print(interest)
                sendPreferenceValues.append(interest)
            }
            interest = interest + 1
        }
    }
    
    
    func postData() {
        let json: [String: Any] = [ "userName" : name,
                                    "userNickname" : nickName,
                                    "signupType" : 0, //0은 카카오톡, 1은 네이버
            "accessToken" : KOSession.shared()?.token.accessToken as Any,
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

        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://52.78.86.179:8080/user")!
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
            }
        }
    }
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
