//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import Lottie

protocol UpdateDelegate: class {
    func updateCareer(type: Int)
}

class AddActivityVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!

    weak var delegate: UpdateDelegate?
    var isNewActivity: Bool = true
    
    private var titleString : String?
    private var contentTextString: String?
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: nil)
    
    var activityData: careerData? {
        didSet {
            guard let data = self.activityData else {return}
            
            self.titleString = data.careerName
            self.contentTextString = data.careerContent
        }
    }
    
    private let activityService: ActivityService
        = DependencyContainer.shared.getDependency(key: .activityService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        tapGesture.delegate = self
        
        setupLayout()
        setStartEndDate()
        
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
    
    private func setupLayout() {
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setStartEndDate() {
        
        guard let data = self.activityData else {return}
        
        let startDate: Date = DateCaculate.stringToDateWithBasicFormatter(using: data.careerDate1 ?? "")
        let endDate: Date = DateCaculate.stringToDateWithBasicFormatter(using: data.careerDate2 ?? "")
        
        var startDateString = ""
        var endDateString = ""
        
        let startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        
        let endDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
        
        guard let startYear = startDateComponents.year else {return}
        guard let startMonth = startDateComponents.month else {return}
        guard let startDay = startDateComponents.day else {return}
        
        startDateString = "\(startYear)년 \(startMonth)월 \(startDay)일"
        
        guard let endYear = endDateComponents.year else {return endDateString = ""}
        guard let endMonth = endDateComponents.month else {return endDateString = ""}
        guard let endDay = endDateComponents.day else {return endDateString = ""}
        
        endDateString = "\(endYear)년 \(endMonth)월 \(endDay)일"
        
        startDateLabel.text = startDateString
        endDateLabel.text = endDateString
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
        guard titleTextField.hasText else {
            simplerAlert(title: "활동명을 입력해주세요")
            return
        }
        
        postData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        let myPageStoryBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        let datePickerPopUpVC = myPageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.datePickerPopUpViewController) as! DatePickerPopUpVC
        
        if button.tag == 0 {
            datePickerPopUpVC.defaultDate = startDateLabel.text!
        } else {
            datePickerPopUpVC.defaultDate = endDateLabel.text!
        }
        
        datePickerPopUpVC.activityCategory = ActivityCategory.AddActivityVC
            
        self.addChild(datePickerPopUpVC)
        datePickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(datePickerPopUpVC.view)
        datePickerPopUpVC.didMove(toParent: self)
        
        datePickerPopUpVC.buttonTag = button.tag
    
    }
    
    private func stringConverted(with: String) -> String {
        
        var intArray: [Int] = []
        var monthString: String = ""
        var dayString: String = ""
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
    
    struct Converter {
        
        static func convertToFormat(of date: String) -> String {
            
            var intArray: [Int] = []
            var monthString: String = ""
            var dayString: String = ""
            let stringArray = date.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            for item in stringArray {
                if let number = Int(item) {
                    intArray.append(number)
                }
            }
            
            monthString = intArray[1] >= 10 ? "\(intArray[1])" : "0\(intArray[1])"
            dayString = intArray[2] >= 10 ? "\(intArray[2])" : "0\(intArray[2])"
            
            return "\(intArray[0])-\(monthString)-\(dayString)"
        }
    }
    
    func postData() {
        
        guard let startData = startDateLabel.text else {
            return
        }
        
        guard let endData = endDateLabel.text else {
            return
        }
        
        let sendStartData = Converter.convertToFormat(of: startData)
        
        let sendEndData = stringConverted(with: endData)
        
        let content =
            contentTextView.text == "동아리, 서포터즈, 봉사활동 등 본인이 했던 대외활동에 대한 구체적인 내용을 작성해보세요!"
                ? "" : contentTextView.text ?? ""
        
        if isNewActivity {
            
            let json: [String: Any] = [
                "careerType": 0,
                "careerName": titleTextField.text ?? "",
                "careerContent": content,
                "careerDate1": sendStartData,
                "careerDate2": sendEndData
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
                            
                            self?.delegate?.updateCareer(type: 0)
                            
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
            guard let idx = activityData?.careerIdx else {
                return
            }
            
            let json: [String: Any] = [
                "careerIdx" : idx,
                "careerType": 0,
                "careerName": titleTextField.text ?? "",
                "careerContent": content,
                "careerDate1": sendStartData,
                "careerDate2": sendEndData
            ]
            
            activityService.requestEditActivity(json) { [weak self] dataResponse in
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
                            
                            self?.delegate?.updateCareer(type: 0)
                            
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
    
}

extension AddActivityVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return true
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
