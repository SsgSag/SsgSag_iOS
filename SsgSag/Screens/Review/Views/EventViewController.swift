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
        
        if nameTextField.text == "" {
            self.simplerAlert(title: "빈칸을 확인해주세요")
            return
        }
        if let phoneText = phoneTextField.text {
            if phoneText == "" {
                self.simplerAlert(title: "빈칸을 확인해주세요")
                return
            } else if !phoneText.isValidPhone() {
                self.simplerAlert(title: "번호형식을 확인해주세요")
                return
            }
        }
        service?.requestReviewEvent(type: 0, name: nameTextField.text!, phone: phoneTextField.text!, completion: { isSuccess in
            if isSuccess {
                self.simpleAlertwithHandler(title: "응모되었어요", message: "") { _ in
                    self.dismiss(animated: true)
                }
            } else {
                self.simplerAlert(title: "다시 시도해주세요!")
            }
        })
    }
}

extension EventViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
