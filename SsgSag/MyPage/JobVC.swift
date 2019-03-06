//
//  JobVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class JobVC: UIViewController {
    
    let unActiveButtonImages: [String] = [
        "btJobManagementUnactive", "btJobMarketingUnactive", "btJobTechUnactive", "btJobDesignUnactive", "btJobTradeUnactive", "btJobSalesUnactive", "btJobServiceUnactive", "btJobStudyUnactive",
        "btJobIndustryUnactive", "btJobLiteratureUnactive", "btJobConstructUnactive", "btJobMedicalUnactive",
        "btJobArtUnactive", "btJobSpecialityUnactive"
        
    ]
    
    let activeButtonImages: [String] = [
        "btJobManagementActive", "btJobMarketingActive", "btJobTechActive", "btJobDesignActive", "btJobTradeActive", "btJobSalesActive", "btJobServiceActive",
        "btJobStudyActive", "btJobIndustryActive", "btJobLiteratureActive", "btJobConstructActive", "btJobMedicalActive", "btJobArtActive", "btJobSpecialityActive"
    ]
    
    var selectedValue: [Bool] = []
    
    @IBOutlet var jobButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var jobSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpJobButtons()
        changeStateJobButtons()
        
        saveButton.isUserInteractionEnabled = false
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpJobButtons(_ sender: UIButton) {
        print(sender.tag)
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        //saveData()
        
        simplerAlert(title: "저장되었습니다")
    }
    @IBAction func valueChangeJobSwitch(_ sender: Any) {
        changeStateJobButtons()
    }
    /*
    private func saveData() {
        
            
            var selectedInterests: [Int] = []
            
            for i in 0..<selectedValue.count {
                if selectedValue[i] == true {
                    selectedInterests.append(i)
                }
            }
            
            let json: [String: Any] = [
                "userInterest" : selectedInterests
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            let url = URL(string: "http://52.78.86.179:8080/user/reInterestReq1")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let token = UserDefaults.standard.object(forKey: "SsgSagToken") as! String
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            NetworkManager.shared.getData(with: request) { (data, error, res) in
                guard let data = data else {
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let responseJSON = responseJSON as? [String: Any] {
                    if let statusCode = responseJSON["status"] {
                        let status = statusCode as! Int
                        if status == 200 {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "저장되었습니다.", message: nil, preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                                    
                                    print("확인 되었습니다")
                                    self.dismiss(animated: true, completion: nil)
                                })
                                
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.simplerAlert(title: "저장에 실패하였습니다")
                            }
                        }
                    }
                }
            }
    }
    */
    
    func setUpJobButtons() {
        var count = 0
        for button in jobButtons {
            button.tag = count
            count += 1
        }
        jobButtons.forEach { (button) in
            button.isSelected = false
        }
        for _ in 0 ..< count {
            selectedValue.append(false)
        }
    }
    
    func changeStateJobButtons() {
        if jobSwitch.isOn == false {
            jobButtons.forEach { (button) in
                button.isSelected = false
                button.setImage(UIImage(named: unActiveButtonImages[button.tag]), for: .normal)
                button.isUserInteractionEnabled = false
            }
            saveButton.isSelected = false
            saveButton.isUserInteractionEnabled = false
        } else {
            jobButtons.forEach { (button) in
                button.isUserInteractionEnabled = true
            }
            saveButton.isUserInteractionEnabled = true
        }
    }
    
    func myButtonTapped(myButton: UIButton, tag: Int) {
        if myButton.isSelected {
            myButton.isSelected = false;
            selectedValue[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
        } else {
            myButton.isSelected = true;
            selectedValue[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
        }
        
        if selectedValue.contains(true) {
            saveButton.setImage(UIImage(named: "btSaveMypageActive"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "btSaveMypageUnactive"), for: .normal)
        }
    }
    
    
    
}
