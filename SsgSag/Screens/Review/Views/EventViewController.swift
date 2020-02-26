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
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
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
    }
}

extension EventViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
