
//
//  sendDataViewController.swift
//  SsgSag
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class sendDataViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func touchUpStartButton(_ sender: Any) {
        
        postData()

    }
}

func postData() {
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
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
    }
    
    let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
        if let data = data, let response = response as? HTTPURLResponse {
            print("response: \(response)")
            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("값을 json으로 받을수없음")
                return
            }
            print("//////////////////")
            print(jsonToArray)
            print("//////////////////")
            
        }
        
        guard error == nil else{
            print("Error occur: \(String(describing: error))")
            return
        }
    }
    dataTask.resume()
    
}
