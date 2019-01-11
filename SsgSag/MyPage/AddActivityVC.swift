//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
//TODO: 저장하기, 텍스트뷰
class AddActivityVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
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
    
    func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            textView.text = "동아리, 서포터즈, 봉사활동 등 본인이 했던 대외활동에 내한 구체적인 내용을 작성해보세요!"
            textView.textColor = UIColor.rgb(red: 189, green: 189, blue: 189)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "동아리, 서포터즈, 봉사활동 등 본인이 했던 대외활동에 내한 구체적인 내용을 작성해보세요!") {
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
