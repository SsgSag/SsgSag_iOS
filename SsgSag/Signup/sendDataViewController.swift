
//
//  sendDataViewController.swift
//  SsgSag
//
//  Created by admin on 02/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Alamofire

class sendDataViewController: UIViewController {


    @IBAction func sendData(_ sender: Any) {
        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
