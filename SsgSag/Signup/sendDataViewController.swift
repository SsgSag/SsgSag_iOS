
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
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters = [
            "userEmail" : "gumgim95@naver.com",
            "userPw" : "784512",
            "userName" : "김현수",
            "userUniv" : "00대학교",
            "userMajor" :"00전공",
            "userStudentNum" :"201732038",
            "userGender" :"male",
            "userBirth" :"980807",
            "userPushAllow" : "1",
            "userInfoAllow" : "1",
            "userInterest[0]" : 1, // 관심분야 인덱스
            //"userInterest[1]" : 2,
            //"userInterest[2]" : 4,
            //"profile" : 파일선택 (@RequestPart(value = "profile", required = false) final MultipartFile profile)
            ] as [String : Any]
        
        let url = URL(string: "http://13.209.212.209:8080/users")!
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            print(response.request)
            print()
            print(response.response)
            print()
            print(response.data)
            
            print()
            print(response.error)
        }
        
//        Alamofire.request(.POST, url, parameters: parameters, headers: headers, encoding: .URLEncodedInURL).response { request, response, data, error in
//            print(request)
//            print(response)
//            print(data)
//            print(error)
//        }
    }
        
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
//
//            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
//            let swipeVC = storyboard.instantiateViewController(withIdentifier: "Swipe")
//            self.present(swipeVC, animated: true, completion: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
