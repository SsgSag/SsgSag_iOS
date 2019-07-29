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
    
    private let careerService: CareerService
        = DependencyContainer.shared.getDependency(key: .careerService)
    
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
        
        careerService.requestCareerWith(body: json) { [weak self] result in
            switch result {
            case .success(let career):
                switch career {
                case .secondSucess:
                    DispatchQueue.main.async {
                        
                        //저장되었습니다 확인을 누르고 나서 parentVC.getData()를 하면 좋을것 같습니다.
                        self?.simplerAlertwhenSave(title: "저장되었습니다")
                        let parentVC = self?.presentingViewController as! CareerVC
                        
                        parentVC.getData(careerType: 1)
                    }
                case .dataBaseError:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "데이터베이스 에러\n저장에 실패했습니다")
                        return
                    }
                case .serverError:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "서버 에러\n저장에 실패했습니다")
                        return
                    }
                default:
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "저장에 실패했습니다")
                        return
                    }
                }
            case .failed(let error):
                print(error)
                return
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
