//
//  AddCertificationVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 7..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class AddCertificationVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    var titleString: String?
    var yearString: String?
    var contentString: String?
    var index: Int?
    
    weak var delegate: UpdateDelegate?
    var isNewActivity: Bool = true
    
    private let activityService: ActivityService
        = DependencyContainer.shared.getDependency(key: .activityService)
    
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
        
        titleTextField.placeholder = "자격증 입력"
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        if let title = titleString {
            titleTextField.text = title
        }
        
        if let content = contentString {
            contentTextView.text = content
        }
    }
    
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        //TODO: - 네트워크 연결
        postData()
    }
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postData() {
        
        if isNewActivity {
            
            let json: [String: Any] = [
                "careerType" : 2,
                "careerName" : titleTextField.text ?? "",
                "careerContent" : contentTextView.text ?? "",
                "careerDate1" : dateButton.titleLabel?.text ?? "" //일까지 줘도 상관없음 ex)"2019-01-12"
            ]
            
            activityService.requestStoreActivity(json) { [weak self] dataResponse in
                switch dataResponse {
                case .success(let activity):
                    
                    guard let statusCode = activity.status,
                        let httpStatus = HttpStatusCode(rawValue: statusCode) else {
                            return
                    }
                    
                    DispatchQueue.main.async {
                        switch httpStatus {
                        case .secondSucess:
                            let animation = LOTAnimationView(name: "bt_save_round")
                            self?.saveButton.addSubview(animation)
                            
                            animation.play()
                            
                            self?.simplerAlertwhenSave(title: "저장되었습니다")
                            
                            self?.delegate?.updateCareer(type: 2)
                            
                        case .serverError, .dataBaseError:
                            DispatchQueue.main.async {
                                self?.simplerAlert(title: "저장에 실패했습니다")
                            }
                        default:
                            break
                        }
                    }
                case .failed(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "저장에 실패했습니다")
                    }
                }
            }
            
        } else {
            
            let json: [String: Any] = [
                "careerIdx": index,
                "careerType" : 2,
                "careerName" : titleTextField.text ?? "",
                "careerContent" : contentTextView.text ?? "",
                "careerDate1" : dateButton.titleLabel?.text ?? "" //일까지 줘도 상관없음 ex)"2019-01-12"
            ]
            
            activityService.requestEditActivity(json) { [weak self] (dataResponse) in
                switch dataResponse {
                case .success(let activity):
                    
                    guard let statusCode = activity.status,
                        let httpStatus = HttpStatusCode(rawValue: statusCode) else {
                            return
                    }
                    
                    DispatchQueue.main.async {
                        switch httpStatus {
                        case .processingSuccess:
                            let animation = LOTAnimationView(name: "bt_save_round")
                            self?.saveButton.addSubview(animation)
                            
                            animation.play()
                            
                            self?.simplerAlertwhenSave(title: "수정되었습니다")
                            
                            self?.delegate?.updateCareer(type: 2)
                            
                        case .serverError, .dataBaseError:
                            DispatchQueue.main.async {
                                self?.simplerAlert(title: "수정에 실패했습니다")
                            }
                        default:
                            break
                        }
                    }
                    
                case .failed(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "수정에 실패했습니다")
                    }
                }
            }
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
    
    @IBAction func addActiveDate(_ sender: UIButton) {
        popUpDatePicker(button: sender, activityCategory: ActivityCategory.AddCertificationVC)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
