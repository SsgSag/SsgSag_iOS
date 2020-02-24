//
//  InputUserClubInfoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SearchTextField

class InputUserClubInfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clubNameTextField: SearchTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startDateLabel: UITextField!
    @IBOutlet weak var endDateLabel: UITextField!
    @IBOutlet weak var univOrLoaclImgView: UIImageView!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var univOrLocalTextField: SearchTextField!
    @IBOutlet weak var univOrLocalLabel: UILabel!
    var clubactInfo: ClubActInfoModel!
    let disposeBag = DisposeBag()
    var service: ClubServiceProtocol?
    var jsonResult: [[String: Any]] = [[:]]
    var isExistClub = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ClubService()
        typeSetting(type: clubactInfo.clubType)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.delegate = self
        bind(model: clubactInfo)
        nextButton.deviceSetSize()
    }
    
    func typeSetting(type: ClubType) {
        if type == .School {
            self.univOrLocalLabel.text = "소속 학교는"
            configureSimpleLocalUnivSearchTextField()
            configureSimpleClubNameSearchTextField()
        } else {
            self.univOrLocalLabel.text = "활동지역은"
            configureSimpleClubNameSearchTextField()
            self.localButton.isHidden = false
            self.univOrLocalTextField.isEnabled = false
            self.univOrLoaclImgView.isHidden = false
        }
    }
    
    private func configureSimpleClubNameSearchTextField() {
        clubNameTextField.startVisible = true
    }
    
    private func configureSimpleLocalUnivSearchTextField() {
        univOrLocalTextField.startVisible = true
        let universities = localUniversities()
        univOrLocalTextField.filterStrings(universities)
        univOrLocalTextField.itemSelectionHandler = { item, itemPosition in
            self.univOrLocalTextField.text = item[itemPosition].title
            self.clubactInfo.univName = item[itemPosition].title
        }
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
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func bind(model: ClubActInfoModel) {
        if model.clubType == .Union {
            model.location
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] locationString in
                    self?.univOrLocalTextField.text = locationString
                    self?.isEnableButton()
                })
                .disposed(by: disposeBag)
        }
        
        model.startDate
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] dateString in
                self?.startDateLabel.text = dateString
                self?.isEnableButton()
            })
            .disposed(by: disposeBag)
        
        model.endDate
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] dateString in
                self?.endDateLabel.text = dateString
                self?.isEnableButton()
            })
            .disposed(by: disposeBag)
        
        clubNameTextField.rx
            .value
            .changed
            .compactMap{ $0 }
            .asObservable()
            .do(onNext: { [weak self] clubName in
                self?.isEnableButton()
                self?.isExistClub = false
                self?.clubactInfo.clubName = clubName
            })
            .subscribe(onNext: { [weak self] clubName in
                guard let service = self?.service else {return}
                guard let location = self?.univOrLocalTextField.text else {return}
                guard let clubactInfo = self?.clubactInfo else {return}
                
                service.requestClubListWithForm(clubType: clubactInfo.clubType, location: location, keyword: clubName, curPage: 0) { clubList in
                    guard let clubList = clubList else {return}
                    guard !clubList.isEmpty else {return}
                    self?.isExistClub = true
                    DispatchQueue.main.async {
                        self?.searchLocalClubListSet(clubList: clubList)
                    }
                    
                }
            })
            .disposed(by: disposeBag)
        
        univOrLocalTextField.rx
            .value
            .changed
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.isEnableButton()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func isEnableButton() {
        guard !(clubNameTextField.text?.isEmpty ?? true) else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
            
            return
        }
        guard !(univOrLocalTextField.text?.isEmpty ?? true) else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
            
            return
        }
        guard !(startDateLabel.text?.isEmpty ?? true) else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
            
            return
        }
        guard !(endDateLabel.text?.isEmpty ?? true) else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
            
            return
        }
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = .cornFlower
        
    }
    
    func searchLocalClubListSet(clubList: [ClubListData]) {
        let clubNameList = clubList.compactMap { $0.clubName }
        clubNameTextField.filterStrings(clubNameList)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        clubactInfo.inputType = .location
        nextVC.clubactInfo = self.clubactInfo
        
        present(nextVC, animated: true, completion: nil)
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
    
    @IBAction func nextClick(_ sender: Any) {
        // 자동완성 목록에 없는학교 거르기
        if clubactInfo.clubType == .School {
            guard let school = univOrLocalTextField.text else {return}
            
            let universities = localUniversities()
            if !universities.contains(school) {
                self.simpleAlert(title: "학교명을 정확히 입력해주세요.", message: "목록에 없는 학교이름 입니다.\n자신의 학교가 없는 경우 문의주세요.")
                return
            }
        }
        
        // 동아리가 등록되어 있다면
        if isExistClub {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "StarRatingVC") as! StarRatingViewController
            nextVC.clubactInfo = clubactInfo
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        } else {
            // 동아리가 등록되어있지 않다면
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NotFoundClubVC") as! NotFoundClubViewController
            nextVC.clubactInfo = clubactInfo
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension InputUserClubInfoViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        clubNameTextField.hideResultsList()
        univOrLocalTextField.hideResultsList()
        self.view.endEditing(true)
    }
}
