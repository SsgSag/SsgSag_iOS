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
    @IBOutlet weak var completeButton: UIButton!
    
    var reviewEditViewModel: ReviewEditViewModel!
    var reviewService: ReviewServiceProtocol!
    
    let textLengthMaximum = 20
    lazy var blackStar = UIImage(named: "icStar0")
    lazy var fillStar = UIImage(named: "icStar2")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.delegate = self
        
        completeButton.deviceSetSize()
        activeBind(model: reviewEditViewModel.clubActInfo)
        typeSetting(type: reviewEditViewModel.clubActInfo.clubType)
        starSetting(model: reviewEditViewModel.reviewInfo)
        simpleReviewSetting(model: reviewEditViewModel.reviewInfo)
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
    
    func typeSetting(type: ClubType) {
        if type == .School {
            univOrLocalLabel.text = "소속 학교는"
            univOrLocalTextField.text = reviewEditViewModel.clubActInfo.univName
        
        } else {
            univOrLocalLabel.text = "활동지역은"
            univOrLocalTextField.text = reviewEditViewModel.clubActInfo.location.value
        }
      
        let startDate = DateCaculate.RequestDateStringToShowDateFormatter(string: reviewEditViewModel.reviewInfo.clubStartDate)
        reviewEditViewModel.clubActInfo.startDate.accept(startDate)
        reviewEditViewModel.clubActInfo.startRequestDate = reviewEditViewModel.reviewInfo.clubStartDate
        let endDate = DateCaculate.RequestDateStringToShowDateFormatter(string: reviewEditViewModel.reviewInfo.clubEndDate)
        reviewEditViewModel.clubActInfo.endDate.accept(endDate)
        reviewEditViewModel.clubActInfo.endRequestDate = reviewEditViewModel.reviewInfo.clubEndDate
        
        clubNameTextField.text = reviewEditViewModel.clubActInfo.clubName
        
    }
    
    func activeBind(model: ClubActInfoModel) {
        
        model.startDate
            .subscribe(onNext: { [weak self] dateString in
                self?.startDateLabel.text = dateString
            })
            .disposed(by: disposeBag)
        
        model.endDate
            .subscribe(onNext: { [weak self] dateString in
                self?.endDateLabel.text = dateString
            })
            .disposed(by: disposeBag)
    
    }
    
    func starSetting(model: ReviewInfo) {
        let recommendScore = model.score0
        recommendButtons.forEach{
            if $0.tag < recommendScore {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.recommendDegreeObservable.accept(recommendScore)
        }
        
        let funScore = model.score1
        funButtons.forEach{
            if $0.tag < funScore {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.funDegreeObservable.accept(funScore)
        }
        
        let proScore = model.score2
        proButtons.forEach{
            if $0.tag < proScore {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.proDegreeObservable.accept(proScore)
        }
        let hardScore = model.score3
        hardButtons.forEach{
            if $0.tag < hardScore {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.hardDegreeObservable.accept(hardScore)
        }
        
        let friendScore = model.score4
        friendButtons.forEach{
            if $0.tag < friendScore {
                $0.setImage(self.fillStar, for: .normal)
            } else {
                $0.setImage(self.blackStar, for: .normal)
            }
            reviewEditViewModel.friendDegreeObservable.accept(friendScore)
        }
    }
    
    func simpleReviewSetting(model: ReviewInfo) {
        oneLineTextField.text = model.oneLine
        advantageTextView.text = model.advantage
        disadvantageTextView.text = model.disadvantage
        honeyTextView.text = model.honeyTip
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
    
    @IBAction func startDateClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        reviewEditViewModel.clubActInfo.inputType = .start
        nextVC.clubactInfo = reviewEditViewModel.clubActInfo
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func endDateClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubActInfoAlertVC") as! ClubActInfoAlertViewController
        reviewEditViewModel.clubActInfo.inputType = .end
        nextVC.clubactInfo = reviewEditViewModel.clubActInfo
        
        present(nextVC, animated: true, completion: nil)
    }
    
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
    
    @IBAction func completeModifyClick(_ sender: Any) {
        guard advantageTextView.text.count >= textLengthMaximum else {
            self.simplerAlert(title: "글자 수를 확인해주세요.")
            return
        }
        guard disadvantageTextView.text.count >= textLengthMaximum else {
            self.simplerAlert(title: "글자 수를 확인해주세요.")
            return
        }
        reviewService.requestModifyReview(model: reviewEditViewModel) { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteViewController
                    nextVC.titleText = "수정이\n완료되었습니다 :)"
                    nextVC.isEditMode = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.simplerAlert(title: "다시 시도해주세요.")
                }
            }
        }
    }
}


extension ReviewEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
