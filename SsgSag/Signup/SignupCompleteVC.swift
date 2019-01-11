
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
        navigationController?.navigationItem.leftBarButtonItem?.image = UIImage(named: "icHeaderArrowBack")
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
       
        var json: [String: Any] = ["userEmail" : id,
                                   "userPw" : password,
                                   "userId" : nickName,
                                   "userName" : name,
                                   "userUniv" : school,
                                   "userMajor" : major,
                                   "userStudentNum" :number,
                                   "userGender" : gender,
                                   "userBirth" : birth,
                                   "userPushAllow" : 1,
                                   "userInfoAllow" : 1,
                                   "userInterest" : sendPreferenceValues
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://54.180.79.158:8080/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //        print(data)
            //        print(response)
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("responseJSON \(responseJSON)")
            }
        }
        
        task.resume()
    }
    
    func postMethodData() {
        
        let defaultSession = URLSession(configuration: .default)
        let urlstring = "http://54.180.79.158:8080/users"
        //    let parameters = ["id": "dksin8659", "password": "dk921212"]
        let parameters = [
            "userEmail" : "aa@naver.com",
            "userPw" : "aa",
            "userName" : "꼬막",
            "userUniv" : "00대학교",
            "userMajor" :"00전공",
            "userStudentNum" :"201732038",
            "userGender" :"male",
            "userBirth" :"980807",
            "userPushAllow" : "1",
            "userInfoAllow" : "1",
            "userInterest" : "1",
            "userId" : "허수진기요미" // 관심분야 인덱스
            //        "userInterest[1]" : "2"
            //"userInterest[2]" : 4,
            //"profile" : 파일선택 (@RequestPart(value = "profile", required = false) final MultipartFile profile)
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        guard let url = URL(string:urlstring.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)else {
            print("URL is nil")
            return
        }
        
        func getDataFuck() {
            let posterURL = URL(string: "http://54.180.79.158:8080/users")
            var request = URLRequest(url: posterURL!)
            request.httpMethod = "POST"
            
            // let json: [String: Any] = ["title": "ABC",
            //                          "dict": ["1":"First", "2":"Second"]]
            
            let json: [String: Any] = ["userEmail" : "wndzlf@naver.com",
                                       "userPw" : "784512",
                                       "userId" : "heo0807",
                                       "userName" : "김현수",
                                       "userUniv" : "인하대학교",
                                       "userMajor" :"컴퓨터공학과",
                                       "userStudentNum" :"201732038",
                                       "userGender" :"male",
                                       "userBirth" :"980807",
                                       "userPushAllow" : 1,
                                       "userInfoAllow" : 1,
                                       "userInterest[0]" : 1,
                                       "userInterest[2]" : 4,
                                       "userGrade" : 3
            ]
            //let jsonData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.ReadingOptions)
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(response?.description)
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    return
                }
                print("data \(data.description)")
            }
            task.resume()
            
        }
    }
    func getData() {
        var json: [String: Any] = ["userEmail" : "gogos32sing@naver.com",
                                   "userPw" : "12341235",
                                   "userId" : "heo0807",
                                   "userName" : "김현수",
                                   "userUniv" : "인하대학교",
                                   "userMajor" :"컴퓨터공학과",
                                   "userStudentNum" :"201732038",
                                   "userGender" :"male",
                                   "userBirth" :"980807",
                                   "userPushAllow" : 1,
                                   "userInfoAllow" : 1,
                                   "userInterest" : [1,
                                                     2,
                                                     3]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://54.180.79.158:8080/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(data)
            print(response)
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("responseJSON \(responseJSON)")
            }
        }
        
        task.resume()
    }
    /*
     {
     
     "userEmail" : "gumgim95@naver.com",
     "userPw" : "784512",
     "userId" : "heo0807",
     "userName" : "김현수",
     "userUniv" : "인하대학교",
     "userMajor" :"컴퓨터공학과",
     "userStudentNum" :"201732038",
     "userGender" :"male",
     "userBirth" :"980807",
     "userPushAllow" : 1,
     "userInfoAllow" : 1,
     "userInterest[0]" : 1, // 관심분야 인덱스
     "userInterest[1]" : 2,
     "userInterest[2]" : 4,
     "profile" : 파일선택 (@RequestPart(value = "profile", required = false) final MultipartFile profile),
     "userGrade" : 3 //학년
     
     }
     */

}
