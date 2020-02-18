//
//  SimpleReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/06.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleReviewViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var honeyTextView: UITextView!
    @IBOutlet weak var disadvantageTextView: UITextView!
    @IBOutlet weak var advantageTextView: UITextView!
    @IBOutlet weak var honeyBlackLabel: UILabel!
    @IBOutlet weak var disadvantageBlackLabel: UILabel!
    @IBOutlet weak var advantageBlackLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var clubactInfo: ClubActInfoModel!
    let simpleReviewViewModel = SimpleReviewViewModel()
    let disposeBag = DisposeBag()
    let textLengthMaximum = 20
    var service: ReviewServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ReviewService()
        advantageTextView.delegate = self
        disadvantageTextView.delegate = self
        honeyTextView.delegate = self
        oneLineTextField.delegate = self
        
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        
        submitButton.deviceSetSize()
        bind()
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func bind() {
        advantageTextView
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                
                self?.advantageBlackLabel.isHidden = text.count == 0 ? false : true
                self?.simpleReviewViewModel.advantageObservable.accept(text)
                
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
                self?.simpleReviewViewModel.disadvantageObservable.accept(text)
                
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
                self?.simpleReviewViewModel.honeyObservable.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        oneLineTextField
            .rx
            .text
            .orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(simpleReviewViewModel.oneLineObservable)
            .disposed(by: disposeBag)
        
        simpleReviewViewModel.submitButtonEnableObservable
            .subscribe(onNext: { [weak self] bool in
                self?.submitButton.backgroundColor = bool ? .cornFlower : .unselectedGray
            })
            .disposed(by: disposeBag)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
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
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        
        if !simpleReviewViewModel.submitButtonEnableObservable.value {
            self.simpleAlert(title: "조건이 충족되지 않았습니다", message: "20자 이상 입력해주세요.")
            return
        }
        sender.isEnabled = false
        indicator.startAnimating()
        clubactInfo.simpleReivewBind(model: simpleReviewViewModel)
        
        if clubactInfo.isExistClub {
            
            service?.requestExistClubReviewPost(model: clubactInfo) {
                isSuccess in
                
                if isSuccess {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteViewController
                    nextVC.titleText = "등록이\n완료되었습니다 :)"
                    nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        sender.isEnabled = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        sender.isEnabled = true
                        self.simpleAlert(title: "전송 실패", message: "다시 시도해주세요.\n이미 리뷰를 쓰신적이 있다면 작성 할 수 없어요!")
                    }
                }
                
            }
        } else {
            
            service?.requestNonExistClubReviewPost(model: clubactInfo) {
                isSuccess in
                if isSuccess {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteViewController
                    nextVC.titleText = "등록이\n완료되었습니다 :)"
                    nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        self.indicator.stopAnimating()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        self.indicator.stopAnimating()
                        self.simpleAlert(title: "전송 실패", message: "다시 시도해주세요.\n이미 리뷰를 쓰신적이 있다면 작성 할 수 없어요!")
                    }
                }
            }
        }
        
        
    }
}
