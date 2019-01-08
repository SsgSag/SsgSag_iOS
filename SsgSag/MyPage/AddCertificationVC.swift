//
//  AddCertificationVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 7..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class AddCertificationVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
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
        yearTextField.placeholder = currentDateString
        
    }
    @IBAction func touchUpSaveButton(_ sender: UIButton) {
        //TODO: - 네트워크 연결?
    }
    
    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
