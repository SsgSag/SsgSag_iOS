//
//  AddVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie

class AddVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
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
        yearTextField.placeholder = currentDateString
        contentTextView.applyBorderTextView()
        
        contentTextView.delegate = self
        titleTextField.delegate = self
        yearTextField.delegate = self
      
    }
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        //TODO: - 네트워크 연결?
        let animation = LOTAnimationView(name: "bt_save_round")
        saveButton.addSubview(animation)
        animation.play()
        
        getData(careerType: "1")
        postData()
        simplerAlert(title: "저장되었습니다")
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
    
    func getData(careerType: String) {
        
        let json: [String:Any] = [
            "careerType" : 2,
            "careerName" : "자격증",
            "careerContent" : "자격증 내용",
            "careerDate1" : "2019-01",
            "careerDate2" : ""
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
        }
        task.resume()
    }
    
    
    func postData() {
        
        var json: [String: Any] = [
            "careerType" : 1,
            "careerName" : titleTextField.text,
            "careerContent" : contentTextView.text,
            "careerDate1" : yearTextField.text //일까지 줘도 상관없음 ex)"2019-01-12"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://54.180.79.158:8080/career")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        
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
    
   

}

extension UITextView {
    func applyBorderTextView() {
        self.layer.borderColor = UIColor.rgb(red: 235, green: 237, blue: 239).cgColor
        self.layer.borderWidth = 1.0
    }
}
