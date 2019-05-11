//
//  PreferenceVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class PreferenceVC: UIViewController {
    
    @IBOutlet var preferenceButtons: [UIButton]!
    
    @IBOutlet weak var saveButton: UIButton!
    
    private var selectedValue: [Bool] = []
    
    private var myPageService: myPageService?
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpPreferenceButtons(_ sender: UIButton) {
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        postSelectedState()
    }
    
    let unActiveButtonImages: [String] = [
        "btPreferenceIdeaUnactive",
        "btPreferenceEconomyUnactive",
        "btPreferenceDesignUnactive",
        "btPreferenceLiteratureUnactive",
        "btPreferenceArtUnactive",
        "btPreferenceMarketingUnactive",
        "btPreferenceSocietyUnactive",
        "btPreferenceCameraUnactive",
        "btPreferenceStartupUnactive",
        "btPreferenceHealthUnactive",
        "btPreferenceSholarshipUnactive",
        "btPreferenceTechUnactive"
    ]
    
    let activeButtonImages: [String] = [
        "btPreferenceIdeaActive",
        "btPreferenceEconomyActive",
        "btPreferenceDesignActive",
        "btPreferenceLiteratureActive",
        "btPreferenceArtActive",
        "btPreferenceMarketingActive",
        "btPreferenceSocietyActive",
        "btPreferenceCameraActive",
        "btPreferenceStartupActive",
        "btPreferenceHealthActive",
        "btPreferenceSholarshipActive",
        "btPreferenceTechActive"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageService = MyPageServiceImp()
        
        setUpPreferenceButtons()
        
        saveButton.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchSelectedState()
    }
    
    func postSelectedState() {
        
        var selectedInterests: [Int] = []
        
        for index in 0..<selectedValue.count {
            if selectedValue[index] {
                selectedInterests.append(index)
            }
        }
        
        let json: [String: Any] = [
            "userInterest" : selectedInterests
        ]
        
        myPageService?.requestStoreSelectedField(json ) { (dataResponse) in
            guard let httpStatusCode = dataResponse.value?.status else {return}
            
            guard let httpStatus = HttpStatusCode(rawValue: httpStatusCode) else {return}
            
            DispatchQueue.main.async {
                switch httpStatus {
                case .sucess:
                    let alert = UIAlertController(title: "저장되었습니다.", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                        
                        print("확인 되었습니다")
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                case .dataBaseError, .serverError:
                    self.simplerAlert(title: "저장에 실패하였습니다")
                default:
                    break
                }
            }
        }
        
    }
    
    func fetchSelectedState() {
        myPageService?.requestSelectedState { [weak self] (dataResponse) in
            self?.setUpFirstStatus(interests: dataResponse.value?.data?.interests)
        }
    }
    
    func setUpFirstStatus(interests: [Int]?) {
        guard let interests = interests else {
            saveButton.isUserInteractionEnabled = true
            return
        }
        
        for interest in interests {
            
            selectedValue[interest] = true
            
            preferenceButtons[interest].setImage(UIImage(named: activeButtonImages[interest]), for: .normal)
            
            preferenceButtons[interest].isSelected = true
        }
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
            myButton.isSelected = false
            selectedValue[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
            saveButton.isUserInteractionEnabled = true
        } else {
            myButton.isSelected = true;
            selectedValue[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
            saveButton.isUserInteractionEnabled = true
        }
        
        saveButton.setImage(UIImage(named: "btSaveMypageActive"), for: .normal)
    }
}

protocol myPageService: class {
    
    func requestSelectedState(completionHandler: @escaping ((DataResponse<Interests>) -> Void))
    
    func requestStoreSelectedField(_ selectedJson: [String: Any] ,
                                   completionHandler: @escaping ((DataResponse<ReInterest>) -> Void))
    
    func requestStoreAddActivity(_ jsonData: [String: Any],
                                 completionHandler: @escaping ((DataResponse<Activity>) -> Void))
    
    func reqeuestStoreJobsState(_ selectedJson: [String: Any] ,
                                completionHandler: @escaping ((DataResponse<ReInterest>) -> Void))
    
}

