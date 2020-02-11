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
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var model: ClubRegisterModel!
    var viewModel: ClubRegisterThreeStepViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindInput(viewModel: viewModel)
        bindOutput(viewModel: viewModel)
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
                self?.submitButton.backgroundColor = isEnable ? .unselectedGray : .cornFlower
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
    
    @IBAction func submitClick(_ sender: Any) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as? CompleteViewController else {return}
        nextVC.titleText = "등록이\n완료되었습니다 :)"
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
