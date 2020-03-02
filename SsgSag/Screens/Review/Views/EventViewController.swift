//
//  EventViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/26.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var infoCheckButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var service: ReviewServiceProtocol?
    var clubIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        
        submitButton.deviceSetSize()
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    @IBAction func checkBoxClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .cornFlower
            
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = .unselectedGray
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitClick(_ sender: Any) {
    
        guard let name = nameTextField.text else {
            return
        }
        
        if name == "" {
            self.simplerAlert(title: "빈칸을 확인해주세요")
            return
        }
        
        guard let phone = phoneTextField.text else {
            return
        }
        if phone == "" {
            self.simplerAlert(title: "빈칸을 확인해주세요")
            return
        } else if !phone.isValidPhone() {
            self.simplerAlert(title: "번호형식을 확인해주세요")
            return
        }
        guard let clubIdx = clubIdx else {
            return
        }
        submitButton.isEnabled = false
        service?.requestReviewEvent(type: 0, name: name, phone: phone, clubIdx:  clubIdx, completion: { isSuccess in
            DispatchQueue.main.async {
                
                if isSuccess {
                    
                    self.simpleAlertwithHandler(title: "응모되었어요", message: "") { _ in
                        self.dismiss(animated: true)
                    }
                } else {
                    self.simplerAlert(title: "다시 시도해주세요!")
                }
                self.submitButton.isEnabled = true
            }
        })
    }
}

extension EventViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
