//
//  FoundClubViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/05.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FoundClubViewController: UIViewController {
    
    @IBOutlet weak var endDateLabel: UITextField!
    @IBOutlet weak var startDateLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var clubactInfo: ClubActInfoModel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind(model: clubactInfo)
    }
    
    func setupUI() {
        guard let clubName = clubactInfo.clubName else {return}
        questionLabel.text = "\'\(clubName)\'에서\n활동한 시기를 알려주세요"
        
    }
    
    func bind(model: ClubActInfoModel) {
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
        
    }
    
    func isEnableButton() {
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
        
        //비활성 버튼기능
        
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
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "StarRatingVC") as! StarRatingViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
