//
//  SchoolInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class SchoolInfoVC: UIViewController {
    
    var id: String = ""
    var password: String = ""
    var name: String = ""
    var birth: String = ""
    var nickName: String = ""
    var gender: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isUserInteractionEnabled = false
        
        iniGestureRecognizer()
        self.titleLabel.isHidden = false
//        self.titleImage.isHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackBtn( color: .black)
        setNavigationBar(color: .white)
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! SignUpCompleteVC
        navVC.id = id
        navVC.password = password
        navVC.name = name
        navVC.birth = birth
        navVC.gender = gender
        navVC.nickName = nickName
        navVC.school = schoolField.text ?? ""
        navVC.major = majorField.text ?? ""
        navVC.grade = gradeField.text ?? ""
        navVC.number = numberField.text ?? ""
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkInformation(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func checkInformation(_ sender: Any) {
        if (schoolField.hasText && majorField.hasText && gradeField.hasText && numberField.hasText) {
            nextButton.isUserInteractionEnabled = true
            nextButton.setImage(UIImage(named: "btNextActive"), for: .normal)
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewEndEditing")
        checkInformation(self)
    }
    
}

extension SchoolInfoVC : UIGestureRecognizerDelegate {
    
    func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
        self.schoolField.resignFirstResponder()
        self.gradeField.resignFirstResponder()
        self.majorField.resignFirstResponder()
        self.numberField.resignFirstResponder()
    }
    
    private func gestureRecog(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: schoolField))! || (touch.view?.isDescendant(of: gradeField))! || (touch.view?.isDescendant(of: majorField))! || (touch.view?.isDescendant(of: numberField))!{
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
//            print("현재 constraint: \(self.stackViewConstraint.constant)")
//            self.stackViewConstraint.constant = 10
//            self.titleImage.isHidden = true
            self.titleLabel.isHidden = true
            //            let alpha: CGFloat = 0.5
            //            self.titleImage.alpha(alpha)
            //            self.titleImage.opa
            
        })
//        stackViewConstraint.constant = 120
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
//            self.stackViewConstraint.constant = 289
//            print(" constraint: \(self.stackViewConstraint.constant)")
            self.titleLabel.isHidden = false
//            self.titleImage.isHidden = false
            
        })
//        stackViewConstraint.constant = 289
        self.view.layoutIfNeeded()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
