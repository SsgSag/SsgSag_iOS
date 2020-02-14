//
//  ReviewEditViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/14.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SearchTextField

class ReviewEditViewController: UIViewController {

    var reviewEditViewModel: ReviewEditViewModel!
    var reviewService: ReviewServiceProtocol!
    var clubService: ClubServiceProtocol!
    var clubactInfo: ClubActInfoModel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clubNameTextField: SearchTextField!
    @IBOutlet weak var startDateLabel: UITextField!
    @IBOutlet weak var endDateLabel: UITextField!
    @IBOutlet weak var univOrLoaclImgView: UIImageView!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var univOrLocalTextField: SearchTextField!
    @IBOutlet weak var univOrLocalLabel: UILabel!
    
    var jsonResult: [[String: Any]] = [[:]]
    var isExistClub = false
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.delegate = self
        
        bind(model: clubactInfo)
        typeSetting(type: clubactInfo.clubType)
        
    }
    
    @objc func tapHideKeyBoard() {
           self.view.endEditing(true)
       }
    
    //기본값 바인딩해놓기
    
    func typeSetting(type: ClubType) {
        if type == .School {
            univOrLocalLabel.text = "소속 학교는"
            configureSimpleLocalUnivSearchTextField()
            configureSimpleClubNameSearchTextField()
        } else {
            univOrLocalLabel.text = "활동지역은"
            configureSimpleClubNameSearchTextField()
            localButton.isHidden = false
            univOrLocalTextField.isEnabled = false
            univOrLoaclImgView.isHidden = false
        }
        clubactInfo.startDate.accept(reviewEditViewModel.reviewInfo.clubStartDate)
        clubactInfo.endDate.accept(reviewEditViewModel.reviewInfo.clubEndDate)
//        startDateLabel.text = reviewEditViewModel.reviewInfo.clubStartDate
//        endDateLabel.text = reviewEditViewModel.reviewInfo.clubStartDate
        univOrLocalTextField.text = clubactInfo.location.value
        clubNameTextField.text = clubactInfo.clubName
    }
    
    private func configureSimpleClubNameSearchTextField() {
        clubNameTextField.startVisible = true
    }
    
    private func configureSimpleLocalUnivSearchTextField() {
        univOrLocalTextField.startVisible = true
        let universities = localUniversities()
        univOrLocalTextField.filterStrings(universities)
    }
    
    private func localUniversities() -> [String] {
        guard let path = Bundle.main.path(forResource: "majorListByUniv",
                                          ofType: "json") else {
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .dataReadingMapped)
            
            guard let jsonResult
                = try JSONSerialization.jsonObject(with: jsonData,
                                                   options: .allowFragments)
                    as? [[String: Any]] else {
                        return []
            }
            
            self.jsonResult = jsonResult
            
            var resultUnivNames: [String] = []
            
            jsonResult.forEach {
                let univName = "\($0["학교명"]!)"
                if !resultUnivNames.contains(univName) {
                    resultUnivNames.append(univName)
                }
            }
            
            return resultUnivNames
        } catch {
            print("Error parsing jSON: \(error)")
            return []
        }
    }
    
    func bind(model: ClubActInfoModel) {
        if model.clubType == .Union {
            model.location
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] locationString in
                    self?.univOrLocalTextField.text = locationString
                })
                .disposed(by: disposeBag)
        }
        
        model.startDate
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] dateString in
                self?.startDateLabel.text = dateString
            })
            .disposed(by: disposeBag)
        
        model.endDate
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] dateString in
                self?.endDateLabel.text = dateString
            })
            .disposed(by: disposeBag)
        
        clubNameTextField.rx
            .value
            .changed
            .compactMap{ $0 }
            .asObservable()
            .do(onNext: { [weak self] clubName in
                self?.isExistClub = false
                self?.clubactInfo.clubName = clubName
            })
            .subscribe(onNext: { [weak self] clubName in
                guard let service = self?.clubService else {return}
                guard let location = self?.univOrLocalTextField.text else {return}
                guard let clubactInfo = self?.clubactInfo else {return}

                service.requestClubWithName(clubType: clubactInfo.clubType, location: location, keyword: clubName, curPage: 0) { clubList in
                    guard let clubList = clubList else {return}
                    guard !clubList.isEmpty else {return}
                    self?.isExistClub = true
                    DispatchQueue.main.async {
                        self?.searchLocalClubListSet(clubList: clubList)
                    }

                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func searchLocalClubListSet(clubList: [ClubListData]) {
           let clubNameList = clubList.compactMap { $0.clubName }
           clubNameTextField.filterStrings(clubNameList)
       }
    
    @IBAction func startDateClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        clubactInfo.inputType = .start
        nextVC.clubactInfo = self.clubactInfo
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func endDateClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        clubactInfo.inputType = .end
        nextVC.clubactInfo = self.clubactInfo
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func locationClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        clubactInfo.inputType = .location
        nextVC.clubactInfo = self.clubactInfo
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func backClick(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
}


extension ReviewEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        clubNameTextField.hideResultsList()
        univOrLocalTextField.hideResultsList()
        self.view.endEditing(true)
    }
}
