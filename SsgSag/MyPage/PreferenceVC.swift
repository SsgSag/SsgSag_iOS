//
//  PreferenceVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class PreferenceVC: UIViewController {
    
    let unActiveButtonImages: [String] = [
        "btPreferenceIdeaUnactive", "btPreferenceCameraUnactive", "btPreferenceDesignUnactive", "btPreferenceMarketingUnactive", "btPreferenceTechUnactive", "btPreferenceLiteratureUnactive", "btPreferenceSholarshipUnactive", "btPreferenceHealthUnactive", "btPreferenceStartupUnactive", "btPreferenceArtUnactive", "btPreferenceEconomyUnactive", "btPreferenceSocietyUnactive"
    ]
    
    let activeButtonImages: [String] = [
        "btPreferenceIdeaActive", "btPreferenceCameraActive", "btPreferenceDesignActive", "btPreferenceMarketingActive", "btPreferenceTechActive", "btPreferenceLiteratureActive", "btPreferenceSholarshipActive", "btPreferenceHealthActive", "btPreferenceStartupActive", "btPreferenceArtActive", "btPreferenceEconomyActive", "btPreferenceSocietyActive"
    ]
    
    var selectedValue: [Bool] = []
    
    @IBOutlet var preferenceButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreferenceButtons()
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpPreferenceButtons(_ sender: UIButton) {
        //        sender.imageView?.image = UIImage(named: <#T##String#>)
        print(sender.tag)
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        //TODO: - 네트워크 연결
    }
    
    func setUpPreferenceButtons() {
        var count = 0
        for button in preferenceButtons {
            button.tag = count
            count += 1
        }
        preferenceButtons.forEach { (button) in
            button.isSelected = false
        }
        for _ in 0 ..< count {
            selectedValue.append(false)
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

