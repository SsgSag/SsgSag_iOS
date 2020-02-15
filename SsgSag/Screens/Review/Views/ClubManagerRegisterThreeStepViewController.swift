//
//  ClubManagerRegisterThreeStepViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ClubManagerRegisterThreeStepViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var service: ClubServiceProtocol!
    var model: ClubRegisterModel!
    var viewModel: ClubRegisterThreeStepViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindInput(viewModel: viewModel)
        bindOutput(viewModel: viewModel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bindInput(viewModel: ClubRegisterThreeStepViewModel) {
        emailTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.emailObservable)
            .disposed(by: disposeBag)
        
        phoneTextField
        .rx
        .text
        .orEmpty
        .bind(to: viewModel.phoneObservable)
        .disposed(by: disposeBag)
    }
    
    func bindOutput(viewModel: ClubRegisterThreeStepViewModel) {
        viewModel.submitButtonEnableObservable
            .subscribe(onNext: { [weak self] isEnable in
                self?.submitButton.backgroundColor = isEnable ? .cornFlower : .unselectedGray
                self?.submitButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
        
        viewModel.emailObservable
            .subscribe(onNext: { [weak self] emailText in
                self?.model.email = emailText
            })
        .disposed(by: disposeBag)
        
        viewModel.phoneObservable
            .subscribe(onNext: { [weak self] phoneText in
                self?.model.phone = phoneText
            })
        .disposed(by: disposeBag)
    }
    
    func modelInsertData(model: ClubRegisterModel, viewModel: ClubRegisterThreeStepViewModel) {
        model.email = viewModel.emailObservable.value
        model.phone = viewModel.phoneObservable.value
    }
    
    @IBAction func submitClick(_ sender: Any) {
        indicator.startAnimating()
        modelInsertData(model: model, viewModel: viewModel)
        self.submitButton.isEnabled = false
        if model.isReviewExist {
            service.requestMemberReviewClubRegister(admin: 1, dataModel: model) { isSuccess in
                DispatchQueue.main.async {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as? CompleteViewController else {return}
                    nextVC.titleText = "등록이\n완료되었습니다 :)"
                    nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        } else {
            service.requestMemberClubRegister(admin: 1, dataModel: model) { isSuccess in
                DispatchQueue.main.async {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as? CompleteViewController else {return}
                    nextVC.titleText = "등록이\n완료되었습니다 :)"
                    nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
}
