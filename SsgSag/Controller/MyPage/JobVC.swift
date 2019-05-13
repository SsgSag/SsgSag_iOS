//
//  JobVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class JobVC: UIViewController {
    
    static let syncInterestNum = 101
    
    let unActiveButtonImages: [String] = [
        "btJobManagementUnactive", "btJobMarketingUnactive", "btJobTechUnactive", "btJobDesignUnactive", "btJobTradeUnactive", "btJobSalesUnactive", "btJobServiceUnactive", "btJobStudyUnactive",
        "btJobIndustryUnactive", "btJobLiteratureUnactive", "btJobConstructUnactive", "btJobMedicalUnactive",
        "btJobArtUnactive", "btJobSpecialityUnactive"
        
    ]
    
    let activeButtonImages: [String] = [
        "btJobManagementActive", "btJobMarketingActive", "btJobTechActive", "btJobDesignActive", "btJobTradeActive", "btJobSalesActive", "btJobServiceActive",
        "btJobStudyActive", "btJobIndustryActive", "btJobLiteratureActive", "btJobConstructActive", "btJobMedicalActive", "btJobArtActive", "btJobSpecialityActive"
    ]
    
    private var storedJobs: [Int] = []
    
    var selectedValue: [Bool] = []
    
    private var myPageService: myPageService?
    
    private var isOn: isSwitchOn?
    
    @IBOutlet var jobButtons: [UIButton]!
    
    @IBOutlet weak var saveButton: GradientButton!
    
    @IBOutlet weak var jobSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        getStoredJobInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setJobTag()
        
        myPageService = MyPageServiceImp()
        
        setSaveButtonColor()
    }
    
    private func setSaveButtonColor() {
        saveButton.topColor = UIColor.init(displayP3Red: 53 / 255, green: 234 / 255, blue: 227, alpha: 1.0)
        
        saveButton.bottomColor = UIColor(displayP3Red: 168 / 255, green: 71 / 255, blue: 255 / 255, alpha: 1.0)
    }


    private func setJobTag() {
        var count = 0
    
        for button in jobButtons {
            button.tag = count
            count += 1
        }
    
        jobButtons.forEach { (button) in
            button.isSelected = false
            button.isUserInteractionEnabled = false
        }
    
        for _ in 0 ..< count {
            selectedValue.append(false)
        }
        
    }
    
    private func getStoredJobInfo() {
        
        myPageService?.requestSelectedState{ [weak self] (dataResponse) in
            
            guard let response = dataResponse.value else {return}
            
            guard let jobs = response.data else {return}
            
            guard let selected =  jobs.interests else {return}
            
            guard let swicthOnOff = jobs.isSeeker else {return}
            
            guard let swithStatus = isSwitchOn(rawValue: swicthOnOff) else {return}
            
            self?.storedJobs =  selected.filter{$0 >= 100}
            
            let syncButton = self?.storedJobs.map{$0 - JobVC.syncInterestNum}
            
            guard let sync = syncButton else {return}
            
            self?.setSelectedStatus(using: sync)
            
            DispatchQueue.main.async { [weak self] in
                self?.setJobButtonsUsingNetwork()
                self?.setSwitchOnOff(switchStatus: swithStatus)
            }
        }
        
    }
    
    private func setSwitchOnOff(switchStatus: isSwitchOn) {
        switch switchStatus {
        case .on:
            jobSwitch.setOn(true, animated: false)
        
            for jobButton in jobButtons {
                jobButton.isUserInteractionEnabled = true
            }
        case .off:
            jobSwitch.setOn(false, animated: false)
            
            for jobButton in jobButtons {
                jobButton.isUserInteractionEnabled = false
            }
            
        }
        
    }
    
    private func setSelectedStatus(using sync: [Int]) {
        for selected in jobButtons{
            for synced in sync {
                if selected.tag == synced {
                    selected.isSelected = true
                }
            }
        }
    }
    
    private func setJobButtonsUsingNetwork() {
    
        for jobButton in jobButtons {
            if jobButton.isSelected {
                jobButton.setImage(UIImage(named: activeButtonImages[jobButton.tag]), for: .normal)
            } else {
                jobButton.setImage(UIImage(named: unActiveButtonImages[jobButton.tag]), for: .normal)
            }
        }
        
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpJobButtons(_ sender: UIButton) {
        print(sender.tag)
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        
        var sendJsonArray: [Int] = []
        
        for selected in jobButtons {
            if selected.isSelected {
                sendJsonArray.append(selected.tag + JobVC.syncInterestNum)
            }
        }
        
        var isSeeker = 0
        
        if jobSwitch.isOn {
            isSeeker = 1
        } else {
            isSeeker = 0
        }
        
        var json: [String:Any] = [:]
        
        if isSeeker == 1 {
            json = [
                "isSeeker" : isSeeker, //on 했을 때
                "userInterest" : sendJsonArray
            ]
        } else {
            json = [
                "isSeeker" : isSeeker
            ]
        }
        
        myPageService?.reqeuestStoreJobsState(json) { dataResponse in
            guard let response = dataResponse.value else {return}
            
            guard let statusCode = response.status else {return}
            
            guard let status = HttpStatusCode(rawValue: statusCode) else {return}
            
            DispatchQueue.main.async { [weak self] in
                switch status {
                case .sucess:
                    //저장된후 dismiss합시다.
                    self?.successAlarm(title: "저장되었습니다")
                case .dataBaseError, .serverError:
                    self?.simplerAlert(title: "서버 에러가 발생하였습니다 \n 다시 시도해 주세요!")
                default:
                    break
                }
            }
        }
    }
    
    private func chnageIsUserInteraction() {
        
        if jobSwitch.isOn {
            for jobButton in jobButtons {
                jobButton.isUserInteractionEnabled = true
            }
        } else {
            for jobButton in jobButtons {
                jobButton.isUserInteractionEnabled = false
            }
        }
        
    }
    
    @IBAction func tapSwitch(_ sender: Any) {
        
        if jobSwitch.isOn {
            jobSwitch.setOn(false, animated: true)
        } else {
            jobSwitch.setOn(true, animated: true)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.chnageIsUserInteraction()
        }
        
    }

    func myButtonTapped(myButton: UIButton, tag: Int) {
        if myButton.isSelected {
            myButton.isSelected = false
            selectedValue[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
        } else {
            myButton.isSelected = true
            selectedValue[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
        }
    }
    
    private func successAlarm(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

fileprivate enum isSwitchOn:Int {
    case on = 1
    case off = 0
}


