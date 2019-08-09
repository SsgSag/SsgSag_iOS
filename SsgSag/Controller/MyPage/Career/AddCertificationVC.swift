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
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var titleString: String?
    var yearString: String?
    var contentString: String?
    var index: Int = 0
    
    weak var delegate: UpdateDelegate?
    var isNewActivity: Bool = true
    
    private let myPageService: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
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
        
        titleTextField.placeholder = "자격증 입력"
        
        titleTextField.delegate = self
        yearTextField.delegate = self
        contentTextView.delegate = self
        
        if let title = titleString {
            titleTextField.text = title
        }
        
        if let year = yearString {
            yearTextField.text = year
        }
        
        if let content = contentString {
            contentTextView.text = content
        }
    }
    
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        //TODO: - 네트워크 연결
        let animation = LOTAnimationView(name: "bt_save_round")
        saveButton.addSubview(animation)
        animation.play()
        getData(careerType: 2)
        postData()
        //simplerAlert(title: "저장되었습니다")
    }
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getData(careerType: Int) {
        
        let json: [String:Any] = [
            "careerType" : careerType,
            "careerName" : "자격증",
            "careerContent" : "자격증 내용",
            "careerDate1" : "2019-01"
        ]
        
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else { return }
        
        //let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://52.78.86.179:8081/career/\(careerType)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
    
        }
    }
    
    func postData() {
        
        if isNewActivity {
            
            let json: [String: Any] = [
                "careerType" : 2,
                "careerName" : titleTextField.text ?? "",
                "careerContent" : contentTextView.text ?? "",
                "careerDate1" : yearTextField.text ?? "" //일까지 줘도 상관없음 ex)"2019-01-12"
            ]
            
            myPageService.requestStoreAddActivity(json) { [weak self] dataResponse in
                
                if !dataResponse.isSuccess {
                    guard let readError = dataResponse.error as? ReadError else {return}
                    print(readError.printErrorType())
                    
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "저장에 실패했습니다")
                    }
                }
                
                guard let statusCode = dataResponse.value?.status else {return}
                
                guard let httpStatus = HttpStatusCode(rawValue: statusCode) else {return}
                
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
            }
            
        } else {
            
            let json: [String: Any] = [
                "careerIdx": index,
                "careerType" : 2,
                "careerName" : titleTextField.text ?? "",
                "careerContent" : contentTextView.text ?? "",
                "careerDate1" : yearTextField.text ?? "" //일까지 줘도 상관없음 ex)"2019-01-12"
            ]
            
            myPageService.requestEditActivity(json) { [weak self] (dataResponse) in
                
                if !dataResponse.isSuccess {
                    guard let readError = dataResponse.error as? ReadError else {return}
                    print(readError.printErrorType())
                    
                    DispatchQueue.main.async {
                        self?.simplerAlert(title: "수정에 실패했습니다")
                    }
                }
                
                guard let statusCode = dataResponse.value?.status else {return}
                
                guard let httpStatus = HttpStatusCode(rawValue: statusCode) else {return}
                
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
