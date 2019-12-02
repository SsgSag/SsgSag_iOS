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

class AddCertificationVC: UIViewController, UITextFieldDelegate {

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
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: nil)
    
    private let activityService: ActivityService
        = DependencyContainer.shared.getDependency(key: .activityService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDate()
        
        titleTextField.placeholder = "자격증 입력"
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        tapGesture.delegate = self
        
        view.addGestureRecognizer(tapGesture)
        
        if let title = titleString {
            titleTextField.text = title
        }
        
        if let content = contentString {
            if content != "" {
                contentTextView.text = content
                contentTextView.textColor = .black
            }
        }
    }
    
    private func setupDate() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day],
                                                 from: currentDate)
        
        guard let year = components.year,
            let month = components.month,
            let day = components.day else {
                return
        }
        
        let currentDateString: String = "\(year)년 \(month)월 \(day)일"
        
        dateButton.setTitle(currentDateString,
                            for: .normal)
        
    }
    
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        //TODO: - 네트워크 연결
        postData()
    }
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postData() {
        
        let content =
            contentTextView.text == "가지고 있는 자격증에 대해 메모할 내용이 있다면 작성해보세요!"
                ? "" : contentTextView.text ?? ""
        
        if isNewActivity {
            
            let json: [String: Any] = [
                "careerType" : 2,
                "careerName" : titleTextField.text ?? "",
                "careerContent" : content,
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
                            let animation = AnimationView(name: "bt_save_round")
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
                "careerContent" : content,
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
                            let animation = AnimationView(name: "bt_save_round")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AddCertificationVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "가지고 있는 자격증에 대해 메모할 내용이 있다면 작성해보세요!"
            textView.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "가지고 있는 자격증에 대해 메모할 내용이 있다면 작성해보세요!" {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
}

extension AddCertificationVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return true
    }
}
