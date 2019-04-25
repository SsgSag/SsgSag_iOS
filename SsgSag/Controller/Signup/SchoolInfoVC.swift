//
//  SchoolInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import SearchTextField

class SchoolInfoVC: UIViewController, UITextFieldDelegate {
    
    var name: String = ""
    var birth: String = ""
    var nickName: String = ""
    var gender: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var schoolField: SearchTextField!
    @IBOutlet weak var majorField: SearchTextField!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isUserInteractionEnabled = false
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackBtn( color: .black)
        setNavigationBar(color: .white)
        
        schoolField.delegate = self
        majorField.delegate = self
        gradeField.delegate = self
        numberField.delegate = self
        
        schoolField.tag = 1
        majorField.tag = 2
        gradeField.tag = 3
        numberField.tag = 4
        
        // 1 - Configure a simple search text field
        configureSimpleSearchTextField()
        configureSimpleMajorSearchTextField()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder =  self.view.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
   
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        
//        let gradeSequence = 1...4
//        gradeField.text?.filter({ (gradeText) -> Bool in
//            return true
//        })
        
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        guard let SignUpCompleteVC = storyboard.instantiateViewController(withIdentifier: "SignUpCompleteVC") as? SignUpCompleteVC else {return}
        
        SignUpCompleteVC.name = name
        SignUpCompleteVC.birth = birth
        SignUpCompleteVC.gender = gender
        SignUpCompleteVC.nickName = nickName
        SignUpCompleteVC.school = schoolField.text ?? ""
        SignUpCompleteVC.major = majorField.text ?? ""
        SignUpCompleteVC.grade = Int(gradeField.text ?? "") ?? 999
        SignUpCompleteVC.number = numberField.text ?? ""
        
        self.navigationController?.pushViewController(SignUpCompleteVC, animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        registerForKeyboardNotifications()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unregisterForKeyboardNotifications()
//    }
//

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkInformation(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfieldshouldBeginEditing")
        checkInformation(self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInformation(self)
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
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewEndEditing")
        checkInformation(self)
    }
    
    fileprivate func configureSimpleSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        //        schoolField.startVisibleWithoutInteraction = true
        schoolField.startVisible = true
      
        // Set data source
        let universities = localUniversities()
        schoolField.filterStrings(universities)
        
        
    }
    
     fileprivate func configureSimpleMajorSearchTextField() {
          majorField.startVisible = true
        let majors = localMajors()
        majorField.filterStrings(majors)
    }
    
    fileprivate func localUniversities() -> [String] {
        if let path = Bundle.main.path(forResource: "univList", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:String]]
                
                var universityNames = [String]()
                for university in jsonResult {
                    universityNames.append("\(university["schoolName"]!)(\(university["campusName"]!))")
                }
                
                return universityNames
            } catch {
                print("Error parsing jSON: \(error)")
                return []
            }
        }
        return []
    }
    
    fileprivate func localMajors() -> [String] {
        if let path = Bundle.main.path(forResource: "majorList", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:String]]
                
                var majorClass = [String]()
                for major in jsonResult {
                    majorClass.append(major["mClass"]!)
                }
                
                return majorClass
            } catch {
                print("Error parsing jSON: \(error)")
                return []
            }
        }
        return []
    }
}

extension SchoolInfoVC : UIGestureRecognizerDelegate {
    
//    func iniGestureRecognizer() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
//        tap.delegate = self
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
//        self.schoolField.resignFirstResponder()
//        self.gradeField.resignFirstResponder()
//        self.majorField.resignFirstResponder()
//        self.numberField.resignFirstResponder()
//    }
//    
//    private func gestureRecog(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (touch.view?.isDescendant(of: schoolField))! || (touch.view?.isDescendant(of: gradeField))! || (touch.view?.isDescendant(of: majorField))! || (touch.view?.isDescendant(of: numberField))!{
//            return false
//        }
//        return true
//    }
//    
//    @objc func keyboardWillShow(_ notification: NSNotification) {
//        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
//        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
//        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
////            print("현재 constraint: \(self.stackViewConstraint.constant)")
////            self.stackViewConstraint.constant = 10
////            self.titleImage.isHidden = true
//            self.titleLabel.isHidden = true
//            //            let alpha: CGFloat = 0.5
//            //            self.titleImage.alpha(alpha)
//            //            self.titleImage.opa
//            
//        })
////        stackViewConstraint.constant = 120
//        self.view.layoutIfNeeded()
//        
//    }
//    
//    @objc func keyboardWillHide(_ notification: NSNotification) {
//        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
//        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
//        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
////            self.stackViewConstraint.constant = 289
////            print(" constraint: \(self.stackViewConstraint.constant)")
//            self.titleLabel.isHidden = false
////            self.titleImage.isHidden = false
//            
//        })
////        stackViewConstraint.constant = 289
//        self.view.layoutIfNeeded()
//    }
//    
//    func registerForKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    func unregisterForKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
}
