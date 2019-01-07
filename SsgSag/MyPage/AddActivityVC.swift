//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
//TODO: 저장하기, 텍스트뷰
class AddActivityVC: UIViewController {

    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityNavigationBar.barStyle = .black
        startDateLabel.text = ""
        endDateLabel.text = ""
        
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
