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

    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var honeyTextView: UITextView!
    @IBOutlet weak var disadvantageTextView: UITextView!
    @IBOutlet weak var advantageTextView: UITextView!
    @IBOutlet weak var honeyBlackLabel: UILabel!
    @IBOutlet weak var disadvantageBlackLabel: UILabel!
    @IBOutlet weak var advantageBlackLabel: UILabel!
    @IBOutlet var friendButtons: [UIButton]!
    @IBOutlet var hardButtons: [UIButton]!
    @IBOutlet var proButtons: [UIButton]!
    @IBOutlet var funButtons: [UIButton]!
    @IBOutlet var recommendButtons: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clubNameTextField: SearchTextField!
    @IBOutlet weak var startDateLabel: UITextField!
    @IBOutlet weak var endDateLabel: UITextField!
    @IBOutlet weak var univOrLoaclImgView: UIImageView!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var univOrLocalTextField: SearchTextField!
    @IBOutlet weak var univOrLocalLabel: UILabel!
    
    var reviewEditViewModel: ReviewEditViewModel!
    var reviewService: ReviewServiceProtocol!
    var clubService: ClubServiceProtocol!
    var clubactInfo: ClubActInfoModel!
    
    let textLengthMaximum = 20
    lazy var blackStar = UIImage(named: "icStar0")
    lazy var fillStar = UIImage(named: "icStar2")
//    var jsonResult: [[String: Any]] = [[:]]
//    var isExistClub = false
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.delegate = self
        
        activeBind(model: clubactInfo)
        typeSetting(type: clubactInfo.clubType)
        textBind(model: reviewEditViewModel)
        advantageTextView.delegate = self
        disadvantageTextView.delegate = self
        honeyTextView.delegate = self
        oneLineTextField.delegate = self
        
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //기본값 바인딩해놓기
    
    func typeSetting(type: ClubType) {
        if type == .School {
            univOrLocalLabel.text = "소속 학교는"
            //            configureSimpleLocalUnivSearchTextField()
            //            configureSimpleClubNameSearchTextField()
        } else {
            univOrLocalLabel.text = "활동지역은"
//            configureSimpleClubNameSearchTextField()
//            localButton.isHidden = false
//            univOrLocalTextField.isEnabled = false
//            univOrLoaclImgView.isHidden = false
        }
        clubactInfo.startDate.accept(reviewEditViewModel.reviewInfo.clubStartDate)
        clubactInfo.endDate.accept(reviewEditViewModel.reviewInfo.clubEndDate)
//        startDateLabel.text = reviewEditViewModel.reviewInfo.clubStartDate
//        endDateLabel.text = reviewEditViewModel.reviewInfo.clubStartDate
        univOrLocalTextField.text = clubactInfo.location.value
        clubNameTextField.text = clubactInfo.clubName
    }
    
//    private func configureSimpleClubNameSearchTextField() {
//        clubNameTextField.startVisible = true
//    }
//
//    private func configureSimpleLocalUnivSearchTextField() {
//        univOrLocalTextField.startVisible = true
//        let universities = localUniversities()
//        univOrLocalTextField.filterStrings(universities)
//    }
    
//    private func localUniversities() -> [String] {
//        guard let path = Bundle.main.path(forResource: "majorListByUniv",
//                                          ofType: "json") else {
//            return []
//        }
//
//        do {
//            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
//                                    options: .dataReadingMapped)
//
//            guard let jsonResult
//                = try JSONSerialization.jsonObject(with: jsonData,
//                                                   options: .allowFragments)
//                    as? [[String: Any]] else {
//                        return []
//            }
//
//            self.jsonResult = jsonResult
//
//            var resultUnivNames: [String] = []
//
//            jsonResult.forEach {
//                let univName = "\($0["학교명"]!)"
//                if !resultUnivNames.contains(univName) {
//                    resultUnivNames.append(univName)
//                }
//            }
//
//            return resultUnivNames
//        } catch {
//            print("Error parsing jSON: \(error)")
//            return []
//        }
//    }
    
    func activeBind(model: ClubActInfoModel) {
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
//                self?.isExistClub = false
                self?.clubactInfo.clubName = clubName
            })
            .subscribe()
//            .subscribe(onNext: { [weak self] clubName in
//                guard let service = self?.clubService else {return}
//                guard let location = self?.univOrLocalTextField.text else {return}
//                guard let clubactInfo = self?.clubactInfo else {return}

//                service.requestClubWithName(clubType: clubactInfo.clubType, location: location, keyword: clubName, curPage: 0) { clubList in
//                    guard let clubList = clubList else {return}
//                    guard !clubList.isEmpty else {return}
//                    self?.isExistClub = true
//                    DispatchQueue.main.async {
//                        self?.searchLocalClubListSet(clubList: clubList)
//                    }

//                }
//            })
            .disposed(by: disposeBag)
    }
    
    func textBind(model: ReviewEditViewModel){
        advantageTextView
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                
                self?.advantageBlackLabel.isHidden = text.count == 0 ? false : true
                model.advantageObservable.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        disadvantageTextView
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                
                self?.disadvantageBlackLabel.isHidden = text.count == 0 ? false : true
                model.disadvantageObservable.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        honeyTextView
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                
                self?.honeyBlackLabel.isHidden = text.count == 0 ? false : true
                model.honeyObservable.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        oneLineTextField
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(model.oneLineObservable)
            .disposed(by: disposeBag)
    }
    
//    func searchLocalClubListSet(clubList: [ClubListData]) {
//           let clubNameList = clubList.compactMap { $0.clubName }
//           clubNameTextField.filterStrings(clubNameList)
//       }
    
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
    
//    @IBAction func locationClick(_ sender: Any) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
//        clubactInfo.inputType = .location
//        nextVC.clubactInfo = self.clubactInfo
//
//        present(nextVC, animated: true, completion: nil)
//    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recommendClick(_ sender: UIButton) {
        recommendButtons.forEach{
            if $0.tag <= sender.tag {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.recommendDegreeObservable.accept(sender.tag)
        }
    }
    
    @IBAction func funClick(_ sender: UIButton) {
        funButtons.forEach{
            if $0.tag <= sender.tag {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.funDegreeObservable.accept(sender.tag)
        }
    }
    
    @IBAction func proClick(_ sender: UIButton) {
        proButtons.forEach{
            if $0.tag <= sender.tag {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.proDegreeObservable.accept(sender.tag)
        }
    }
    
    @IBAction func hardClick(_ sender: UIButton) {
        hardButtons.forEach{
            if $0.tag <= sender.tag {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.hardDegreeObservable.accept(sender.tag)
        }
    }
    
    @IBAction func friendClick(_ sender: UIButton) {
        friendButtons.forEach{
            if $0.tag <= sender.tag {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.friendDegreeObservable.accept(sender.tag)
        }
    }
    
}


extension ReviewEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        clubNameTextField.hideResultsList()
//        univOrLocalTextField.hideResultsList()
        self.view.endEditing(true)
    }
}

extension ReviewEditViewController: UITextViewDelegate, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let curString = textField.text else { return false }
        guard let stringRange = Range(range, in: curString) else { return false }
        
        let updateText = curString.replacingCharacters(in: stringRange, with: string)
        return updateText.count < textLengthMaximum
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
