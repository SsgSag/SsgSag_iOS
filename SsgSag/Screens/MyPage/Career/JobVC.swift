//
//  JobVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class JobVC: UIViewController {
    
    @IBOutlet var jobButtons: [UIButton]!
    
    @IBOutlet var companysButtons: [UIButton]!
    
    @IBOutlet weak var saveButton: GradientButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentViewOfScrollView: UIView!

    private var viewStatus: ViewStatus = .first
    
    private var isNowMovingStatus = false
    
    enum ViewStatus {
        case first
        case second
    }
    
    static let syncInterestNum = 101
    
    let unActiveButtonImages: [String] = [ "btJobManagementUnactive",
                                           "btJobSpecialityUnactive",
                                           "btJobTechUnactive",
                                           "btJobSalesUnactive",
                                           "btJobDesignUnactive",
                                           "btJobArtUnactive",
                                           "btJobServiceUnactive",
                                           "btJobLiteratureUnactive",
                                           "btJobIndustryUnactive",
                                           "btJobMedicalUnactive",
                                           "btJobConstructUnactive",
                                           "btJobTradeUnactive",
                                           "btJobSocietyPassive",
                                           "btJobEtcPassive"
                                         ]
    
    let activeButtonImages: [String] = [ "btJobManagement",
                                         "btJobSpeciality",
                                         "btJobTech",
                                         "btJobSales",
                                         "btJobDesign",
                                         "btJobMedia",
                                         "btJobService",
                                         "btJobEdu",
                                         "btJobIndustry",
                                         "btJobMedical",
                                         "btJobConstruct",
                                         "btJobTrade",
                                         "btJobSociety",
                                         "btJobEtc"
                                        ]
    
    
    private var storedJobs: [Int] = []
    
    private var storedCompanys: [Int] = []
    
    var selectedValue: [Bool] = []
    
    private let myPageService: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
    override func viewWillAppear(_ animated: Bool) {
        setScrollView()
        
        getStoredJobInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setJobTag()
        
        setSaveButtonColor()
        
        setCompanysButton()
        
        chnageIsUserInteraction()
        
        setScrollView()
    }

    private func setScrollView() {
        scrollView.delegate = self
    }
    
    private func setCompanysButton() {
        companysButtons.forEach { button in
            button.isSelected = false
        }
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
        // FIXME: - companyTags의 값이 제대로 나오지 않습니다.
        myPageService.requestSelectedState{ [weak self] (dataResponse) in
            
            guard let response = dataResponse.value else {return}
            
            guard let jobs = response.data else {return}
            
            guard let selected =  jobs.interests else {return}
            
            self?.storedJobs =  selected.filter{$0 >= 100 && $0 < 10000}
            
            let companyTags = selected.filter{$0 >= 10000}
            
            self?.setSelectedCompanysButton(using: companyTags)
            
            let syncButton = self?.storedJobs.map{$0 - JobVC.syncInterestNum}
            
            guard let sync = syncButton else {return}
            
            self?.setSelectedStatus(using: sync)
            
            DispatchQueue.main.async { [weak self] in
                self?.setJobButtonsUsingNetwork()
            }

        }
    }
    
    private func setSelectedCompanysButton(using tags: [Int]) {
        for selectedCompanyButton in companysButtons {
            for tag in tags {
                if tag == selectedCompanyButton.tag {
                    selectedCompanyButton.isSelected = true
                }
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
        
        for companysButton in companysButtons {
            guard let companysTag = Companys(rawValue: companysButton.tag) else {return}
            if companysButton.isSelected {
                
                companysButton.setImage(UIImage(named: companysTag.resultCompanyActiveImagesString()),
                                        for: .normal)
            } else {
                companysButton.setImage(UIImage(named: companysTag.resultCompanyUnActiveImagesString()),
                                        for: .normal)
            }
        }
        
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpJobButtons(_ sender: UIButton) {
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        
        var sendJsonArray: [Int] = []
        
        for selectedCompanyButton in jobButtons {
            if selectedCompanyButton.isSelected {
                sendJsonArray.append(selectedCompanyButton.tag + JobVC.syncInterestNum)
            }
        }
        
        for selectedCompanyButton in companysButtons {
            if selectedCompanyButton.isSelected {
                sendJsonArray.append(selectedCompanyButton.tag)
            }
        }
        
        let isSeeker = 1
        var json: [String:Any] = [:]
    
        json = [
            "isSeeker" : isSeeker, //on 했을 때
            "userInterest" : sendJsonArray
        ]
        
    }
    
    private func chnageIsUserInteraction() {
        for jobButton in jobButtons {
            jobButton.isUserInteractionEnabled = true
        }
    }

    func myButtonTapped(myButton: UIButton, tag: Int) {
        //직무분야
        if tag < 10000 {
            if myButton.isSelected {
                myButton.isSelected = false
                selectedValue[myButton.tag] = false
                myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
            } else {
                myButton.isSelected = true
                selectedValue[myButton.tag] = true
                myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
            }
        } else { //기업형태
            guard let companyType = Companys(rawValue: tag) else {return}
            
            if myButton.isSelected {
                myButton.isSelected = false
                myButton.setImage(UIImage(named: companyType.resultCompanyUnActiveImagesString()), for: .normal)
            } else {
                myButton.isSelected = true
                myButton.setImage(UIImage(named: companyType.resultCompanyActiveImagesString()), for: .normal)
            }
            
        }
        
    }
    
    private func successAlarm(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func moveFirstView(_ sender: Any) {
        // FIXME: - 왜 setScrollView가 들어가야만 하는지 이유을 모르겠습니다
        //setScrollView()
        viewStatus = .first
        isNowMovingStatus = true
        
        setContentOffsetValueX(by: 0) {
            self.isNowMovingStatus = false
        }
        
    }
    
    @IBAction func moveSecondView(_ sender: Any) {
        //setScrollView()
        viewStatus = .second
        isNowMovingStatus = true
        
        setContentOffsetValueX(by: UIScreen.main.bounds.width) {
            self.isNowMovingStatus = false
        }

    }
    
    private func setContentOffsetValueX(by x: CGFloat,
                                        completion: @escaping () -> Void) {
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        completion()
    }
}

extension JobVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if viewStatus == .first && scrollView.contentOffset.x != 0{
            scrollView.contentOffset.x = 0
        } else if viewStatus == .second {
            scrollView.contentOffset.x = UIScreen.main.bounds.width
        }
        
    }
    
}

fileprivate enum Companys: Int {
    case big = 10000
    case mid = 20000
    case small = 30000
    case startup = 40000
    case publicCompany = 50000
    case foreign = 60000
    
    func resultCompanyUnActiveImagesString() -> String {
        switch self {
        case .big:
            return "btCompanyBigPassive"
        case .mid:
            return "btCompanyMidPassive"
        case .small:
            return "btCompanySmallPassive"
        case .startup:
            return "btCompanyStartupPassive"
        case .publicCompany:
            return "btCompanyPublicPassive"
        case .foreign:
            return "btCompanyForeignPassive"
        }
    }
    
    func resultCompanyActiveImagesString() -> String {
        switch self {
        case .big:
            return "btCompanyBig"
        case .mid:
            return "btCompanyMid"
        case .small:
            return "btCompanySmall"
        case .startup:
            return "btCompanyStartup"
        case .publicCompany:
            return "btCompanyPublic"
        case .foreign:
            return "btCompanyForeign"
        }
    }
    
}
