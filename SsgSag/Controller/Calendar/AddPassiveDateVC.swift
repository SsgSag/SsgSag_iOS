//
//  AddPassiveDateVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Lottie

class AddPassiveDateVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let unActiveButtonImages: [String] = [
    "icCategoryContest", "icCategoryActivity", "icCategoryClub", "icCategorySchool", "icCategoryCareer", "icCategoryExtra"
    ]
    
    let activeButtonImages: [String] = [
     "icCategoryContestActive", "icCategoryActivityActive", "icCategoryClubActive", "icCategorySchoolActive", "icCategoryCareerActive", "icCategoryExtraActive"
    ]
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet var startYearMonthDay: UILabel!
    
    @IBOutlet var startTime: UILabel!
    
    @IBOutlet var endYearMonthDay: UILabel!
    
    @IBOutlet var endTime: UILabel!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    var selectedValues: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        titleField.delegate = self
        memoTextView.delegate = self
        memoTextView.applyBorderTextView()
        if( memoTextView.text == "") { textViewDidEndEditing(memoTextView)
        }
        
    }
    @IBAction func touchUpCategoryButtons(_ sender: UIButton) {
        print(sender.tag)
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func startDateButton(_ sender: UIButton) {
        sender.tag = 0
        popUpDatePicker(button: sender)
    }
    
    @IBAction func endDateButton(_ sender: UIButton) {
        sender.tag = 1
        popUpDatePicker(button: sender)
    }
    
    @IBAction func storeButton(_ sender: UIButton) {
        let animation = LOTAnimationView(name: "bt_save_round")
        sender.addSubview(animation)
        animation.play()
        simplerAlert(title: "저장되었습니다")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpPreferenceButtons() {
        var count = 0
        for button in categoryButtons {
            button.tag = count
            count += 1
        }
        categoryButtons.forEach { (button) in
            button.isSelected = false
        }
        for _ in 0 ..< count {
            selectedValues.append(false)
        }
    }
    
    func myButtonTapped(myButton: UIButton, tag: Int) {
        if myButton.isSelected {
            myButton.isSelected = false
            selectedValues[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
        } else {
            myButton.isSelected = true
            selectedValues[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        memoTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            textView.text = "활동한 내용을 적어주세요."
            textView.textColor = UIColor.rgb(red: 189, green: 189, blue: 189)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "활동한 내용을 적어주세요.") {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func popUpDatePicker(button: UIButton) {
        let myPageStoryBoard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.datePickerPopUpViewController)
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
