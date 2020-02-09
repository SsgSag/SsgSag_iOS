//
//  ClubManagerRegisterOneStepViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClubManagerRegisterOneStepViewController: UIViewController {

    @IBOutlet weak var univOrLocationLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var univOrLocationImg: UIImageView!
    @IBOutlet weak var univOrLocationButton: UIButton!
    @IBOutlet weak var univOrLocationTextField: UITextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    
    var viewModel: ClubRegisterOneStepViewModel!
    var model: ClubRegisterModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput(viewModel: viewModel)
        bindOutput(viewModel: viewModel)
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        clubTypeSetting(clubType: model.clubType)
    }
    
    func bindInput(viewModel: ClubRegisterOneStepViewModel) {
        clubNameTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.clubNameObservable)
            .disposed(by: disposeBag)
        
        univOrLocationTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.univOrLocationObservable)
            .disposed(by: disposeBag)
        
        oneLineTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.oneLineObservable)
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput(viewModel: ClubRegisterOneStepViewModel) {
        viewModel.nextButtonEnableObservable
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEnable in
                self?.nextButton.backgroundColor = isEnable ? .cornFlower : .unselectedGray
                self?.nextButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
        
    }
    
    func clubTypeSetting(clubType: ClubType) {
        if clubType == .School {
            univOrLocationLabel.text = "소속 학교"
        } else {
            univOrLocationLabel.text = "활동 지역"
            univOrLocationImg.isHidden = false
            univOrLocationTextField.isEnabled = false
            univOrLocationButton.isHidden = false
        }
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    @IBAction func selectOptionClick(_ sender: UIButton) {
        let type: InputType = sender.tag == 0 ? .location : .category
        
        guard viewModel.isMaxCategory() else {
            self.simplerAlert(title: "3개를 초과하였습니다.")
            return
        }
        
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubRegisterAlertVC") as? ClubRegisterAlertViewController else {return}
        nextVC.model = model
        nextVC.type = type
        
        self.present(nextVC, animated: true)
    }
    
    @IBAction func nextStepClick(_ sender: Any) {
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ClubManagerRegisterOneStepViewController: UIScrollViewDelegate {}
