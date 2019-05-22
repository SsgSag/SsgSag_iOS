//
//  AddVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie

enum ActivityCategory {
    case AddActivityVC
    case AddVC
    case AddCertificationVC
}

class AddVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    var titleString: String?
    var yearString: String?
    var contentString: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let currentDateString: String = "\(year)년 \(month)월 \(day)일"
        
        dateButton.setTitle(currentDateString, for: .normal)
        
        contentTextView.applyBorderTextView()
        
        contentTextView.delegate = self
        titleTextField.delegate = self
        
        if let title = titleString {
            titleTextField.text = title
        }
    
        if let content = contentString {
            contentTextView.text = content
        }
        
    }
    
    @IBAction func addActiveDate(_ sender: UIButton) {
        popUpDatePicker(button: sender, activityCategory: ActivityCategory.AddVC)
    }
    
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        postData()
    }
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            "careerDate1" : "2019-01",
            "careerDate2" : ""
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://52.")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.object(forKey: TokenName.token) as! String
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
           // guard let data = data else { return }
        }
    }
    
    func popUpDatePicker(button: UIButton, activityCategory: ActivityCategory) {
        
        let myPageStoryBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.datePickerPopUpViewController) as! DatePickerPopUpVC
        
        popVC.activityCategory = activityCategory
        
        self.addChild(popVC)
        
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
    }
    
    func postData() {
        
        let json: [String: Any] = [
            "careerType" : 1,
            "careerName" : titleTextField.text ?? "",
            "careerContent" : contentTextView.text ?? "",
            "careerDate1" : dateButton.titleLabel?.text ?? "" //일까지 줘도 상관없음 ex)"2019-01-12"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://52.78.86.179:8080/career")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.object(forKey: TokenName.token) as! String
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                if let statusCode = responseJSON["status"] {
                    let status = statusCode as! Int
                    if status == 201 {
                        DispatchQueue.main.async {
                            
                            //저장되었습니다 확인을 누르고 나서 parentVC.getData()를 하면 좋을것 같습니다.
                            self.simplerAlertwhenSave(title: "저장되었습니다")
                            let parentVC = self.presentingViewController as! CareerVC
                            
                            parentVC.getData(careerType: 1)
                        }
                    } else  {
                        print("이력추가 실패")
                        DispatchQueue.main.async {
                            self.simplerAlert(title: "저장에 실패했습니다")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.simplerAlert(title: "저장에 실패했습니다")
                    }
                }
            }
        }
    }
}

extension UITextView {
    func applyBorderTextView() {
        self.layer.borderColor = UIColor.rgb(red: 235, green: 237, blue: 239).cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
    }
}
