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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advantageTextView.delegate = self
        disadvantageTextView.delegate = self
        honeyTextView.delegate = self
        oneLineTextField.delegate = self
        
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        
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
                if bool {
                    self?.submitButton.isEnabled = true
                    self?.submitButton.backgroundColor = .cornFlower
                } else {
                    self?.submitButton.isEnabled = false
                    self?.submitButton.backgroundColor = .unselectedGray
                }
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
    
    @IBAction func submitClick(_ sender: Any) {
        clubactInfo.simpleReivewBind(model: simpleReviewViewModel)
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteViewController
        nextVC.titleText = "후기 등록이\n완료되었습니다 :)"
        nextVC.subText = ""
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
