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
        //TODO: - 네트워크 연결
//        let myPageStoryBoard = UIStoryboard(name: "MyPageStoryBoard", bundle: nil)
//        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "PopUp")
//        self.addChild(popVC)
//        popVC.view.frame = self.view.frame
//        self.view.addSubview(popVC.view)
//
//        popVC.didMove(toParent: self)
        simpleAlert(title: "저장", message: "저장되었습니다")
    }
    @IBAction func valueChangeJobSwitch(_ sender: Any) {
        changeStateJobButtons()
    }
    
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
