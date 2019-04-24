//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie
//TODO: 저장하기
class AddActivityVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var titleString : String?
    var startDateString = ""
    var endDateString = ""
    var contentTextString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        let currentDateString: String = "\(year)년 \(month)월 \(day)일"
        
        startDateLabel.text = currentDateString
        endDateLabel.text = currentDateString
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        contentTextView.applyBorderTextView()
        
        if(contentTextView.text == "") {
            textViewDidEndEditing(contentTextView)
        }
        
        if let title = titleString {
            titleTextField.text = title
        }
        
        if let content = contentTextString {
            contentTextView.text = content
        }
        
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
        
        postData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getData(careerType: Int) {
        
        let json: [String:Any] = [
            "careerType" : careerType,
            "careerName" : "자격증",
            "careerContent" : "자격증 내용",
            "careerDate1" : "2019-01"
        ]
        
        //let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://52.78.86.179:8080/career/\(careerType)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.object(forKey: "SsgSagToken") as! String
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            //            guard let data = data else {
            //                return
            //            }
        }
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
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "DatePickerPoPUp") as! DatePickerPopUpVC
        
        popVC.activityCategory = ActivityCategory.AddActivityVC
            
        self.addChild(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
        
        let sendData = popVC
        sendData.buttonTag = button.tag
        
        if startDateLabel != nil {
            sendData.startDateString = startDateLabel.text!
        }
        
        if endDateLabel != nil {
            sendData.endDateString = endDateLabel.text!
            print("endDateLabel전송: \(sendData.endDateString)")
        }
    }
    
    private func stringConverted(with: String) -> String {
        
        var intArray: [Int] = []
        var monthString:String = ""
        var dayString:String = ""
        let stringArray = with.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        for item in stringArray {
            if let number = Int(item) {
                intArray.append(number)
            }
        }
    
        monthString = intArray[1] >= 10 ? "\(intArray[1])" : "0\(intArray[1])"
        dayString = intArray[2] >= 10 ? "\(intArray[2])" : "0\(intArray[2])"
        
        return "\(intArray[0])-\(monthString)-\(dayString)"
    }
    
    func postData() {
        
        guard let startData = startDateLabel.text else {
            return
        }
        
        guard let endData = endDateLabel.text else {
            return
        }
        
        let sendStartData = stringConverted(with: startData)
        
        let sendEndData = stringConverted(with: endData)
        
        print(sendStartData)
        print(sendEndData)
        
        let json: [String: Any] = [
            "careerType" : 0,
            "careerName" : titleTextField.text ?? "",
            "careerContent" : contentTextView.text ?? "",
            "careerDate1" : sendStartData,
            "careerDate2" : sendEndData
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = UserAPI.sharedInstance.getURL("/career") else {return}
        
        guard let token = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // FIXME: - 네트워크 통신 고쳐야 합니다.
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            DispatchQueue.global().async {
                guard let data = data else {
                    return
                }
                
                //print(res)
                do {
                    guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        throw JSONSerializationError.data
                    }
                    
                    guard let responseJson = responseJSON as? [String: Any] else {
                        return
                    }
                    
                    guard let statusCode = responseJson["status"] else {
                        return
                    }
                    
                    guard let status = statusCode as? Int else {
                        return
                    }
                    
                    switch status {
                    case 201:
                        print("이력추가 성공")
                        DispatchQueue.main.async {
                            self.simplerAlertwhenSave(title: "저장되었습니다")
                            let parentVC = self.presentingViewController as! CareerVC
                            parentVC.getData(careerType: 0)
                            parentVC.activityTableView.reloadData()
                        }
                    case 600:
                        print("이력추가 실패")
                        DispatchQueue.main.async {
                            self.simplerAlert(title: "저장에 실패했습니다")
                        }
                    case 500:
                        print("이력추가 실패")
                        DispatchQueue.main.async {
                            self.simplerAlert(title: "저장에 실패했습니다")
                        }
                    default:
                        break
                    }
                    
                } catch {
                    print("이력추가 실패")
                    DispatchQueue.main.async {
                        self.simplerAlert(title: "저장에 실패했습니다")
                    }
                    print("AddActivity Json Parsing Error")
                }
            }
        }
    }
}

enum JSONSerializationError: Error
{
    case file
    case data
    case json
    case key
    case failed
}
