//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie
//TODO: 저장하기, 텍스트뷰
class AddActivityVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let currentDateString: String = "\(year)년 \(month)월 \(day)일"
        
        activityNavigationBar.barStyle = .black
        startDateLabel.text = currentDateString
        endDateLabel.text = currentDateString
        
        contentTextView.applyBorderTextView()
        contentTextView.delegate = self
        if(contentTextView.text == "") {
            textViewDidEndEditing(contentTextView)
        }
//        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        self.view.addGestureRecognizer(tapDismiss)
    }

    @IBAction func touchUpStartDateButton(_ sender: UIButton) {
        sender.tag = 0
        popUpDatePicker(button: sender)
    }
    
    @IBAction func touchUpEndDateButton(_ sender: UIButton) {
        sender.tag = 1
        popUpDatePicker(button: sender)
    }
    
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        let animation = LOTAnimationView(name: "bt_save_round")
        saveButton.addSubview(animation)
        animation.play()
        
        getData(careerType: "0")

        simplerAlert(title: "저장되었습니다")
    
    }
    
    func getData(careerType: String) {
        
        let json: [String:Any] = [
            "careerType" : 2,
            "careerName" : "자격증",
            "careerContent" : "자격증 내용",
            "careerDate1" : "2019-01"
        ]
        
        //let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://54.180.79.158:8080/career")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            guard let data = data else { return }
            
            print(data)
            print("gggg")
            print(response)
            
//            do {
//                let apiResponse = try JSONDecoder().decode(Career.self, from: data)
//                print("orders: \(apiResponse)")
//                if careerType == "0" {
//                    print("00000000")
//                    self.activityList = apiResponse.data
//                    DispatchQueue.main.async {
//                        self.activityTableView.reloadData()
//                    }
//                } else if careerType == "1" {
//                    print("111111111")
//                    self.prizeList = apiResponse.data
//                    DispatchQueue.main.async {
//                        self.prizeTableView.reloadData()
//                    }
//                } else if careerType == "2" {
//                    self.certificationList = apiResponse.data
//                    DispatchQueue.main.async {
//                        self.certificationTableView.reloadData()
//                    }
//                }
//
//            } catch (let err) {
//                print(err.localizedDescription)
//                print("sladjalsdjlasjdlasjdlajsldjas")
//            }
            
            //            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            //            if let responseJSON = responseJSON as? [String: Any] {
            //                //print("responseJSON \(responseJSON)")
            //                //print(responseJSON["data"])
            //                var a = responseJSON["data"]
            //                print(a)
            //                print("1")
            //            }
        }
        task.resume()
    }

    func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            textView.text = "동아리, 서포터즈, 봉사활동 등 본인이 했던 대외활동에 대한 구체적인 내용을 작성해보세요!"
            textView.textColor = UIColor.rgb(red: 189, green: 189, blue: 189)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "동아리, 서포터즈, 봉사활동 등 본인이 했던 대외활동에 대한 구체적인 내용을 작성해보세요!") {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }

    
    func popUpDatePicker(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: "MyPageStoryBoard", bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "DatePickerPoPUp")
        self.addChild(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
    
        popVC.didMove(toParent: self)
        let sendData = popVC as! DatePickerPopUpVC
        sendData.buttonTag = button.tag
        if startDateLabel != nil {
            sendData.startDateString = startDateLabel.text!
        }
        if endDateLabel != nil {
            sendData.endDateString = endDateLabel.text!
            print("endDateLabel전송: \(sendData.endDateString)")
        }
        
    }
    
}
