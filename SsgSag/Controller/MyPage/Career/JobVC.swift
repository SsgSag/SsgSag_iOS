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
    
    @IBOutlet weak var saveButton: GradientButton!
    
    static let syncInterestNum = 101
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentViewOfScrollView: UIView!
    
    @IBOutlet weak var firstStatusView: UIView!
    
    @IBOutlet weak var secondStatusView: UIView!
    
    enum ViewStatus {
        case first
        case second
    }
    
    private var viewStatus: ViewStatus = .first
    
    private var isNowMovingStatus = false
    
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
    
    var selectedValue: [Bool] = []
    
    private var myPageService: myPageService? = MyPageServiceImp()
    
    override func viewWillAppear(_ animated: Bool) {
        setScrollView()
        
        getStoredJobInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusColor()
        
        setJobTag()
        
        setSaveButtonColor()
        
        chnageIsUserInteraction()
        
        setScrollView()
    }
    
    private func setStatusColor() {
        firstStatusView.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.4862745098, blue: 1, alpha: 1)
    }
    
    private func setScrollView() {
        scrollView.contentSize.width = UIScreen.main.bounds.width * 2
        scrollView.delegate = self
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
            
            self?.storedJobs =  selected.filter{$0 >= 100}
            
            let syncButton = self?.storedJobs.map{$0 - JobVC.syncInterestNum}
            
            guard let sync = syncButton else {return}
            
            self?.setSelectedStatus(using: sync)
            
            DispatchQueue.main.async { [weak self] in
                self?.setJobButtonsUsingNetwork()
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
        
        let isSeeker = 1
        var json: [String:Any] = [:]
    
        json = [
            "isSeeker" : isSeeker, //on 했을 때
            "userInterest" : sendJsonArray
        ]
        
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
        for jobButton in jobButtons {
            jobButton.isUserInteractionEnabled = true
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
    
    @IBAction func moveFirstView(_ sender: Any) {
        // FIXME: - 왜 setScrollView가 들어가야만 하는지 이유을 모르겠습니다
        setScrollView()
        viewStatus = .first
        isNowMovingStatus = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func moveSecondView(_ sender: Any) {
        setScrollView()
        viewStatus = .second
        isNowMovingStatus = true
        
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width , y: 0), animated: true)
    }
}

extension JobVC: UIScrollViewDelegate {
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
//                                   withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        //오른쪽으로감
//        if velocity.x > 0 && scrollView.contentOffset.x > UIScreen.main.bounds.width / 2 {
//            scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width , y: 0), animated: true)
//        } else if velocity.x < 0 && scrollView.contentOffset.x < UIScreen.main.bounds.width / 2 {
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isNowMovingStatus {
            if scrollView.contentOffset.x != 0 && viewStatus == .first {
                scrollView.setContentOffset(CGPoint(x:0,
                                                    y:scrollView.contentOffset.y), animated: false)
            } else if scrollView.contentOffset.x != UIScreen.main.bounds.width && viewStatus == .second {
                scrollView.setContentOffset(CGPoint(x:UIScreen.main.bounds.width,
                                                    y:scrollView.contentOffset.y), animated: false)
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isNowMovingStatus = false
    }
    
}

