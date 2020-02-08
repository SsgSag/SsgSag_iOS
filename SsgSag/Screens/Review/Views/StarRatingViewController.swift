//
//  StarRatingViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/06.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StarRatingViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var friendStack: UIStackView!
    @IBOutlet weak var hardDegreeStack: UIStackView!
    @IBOutlet weak var proDegreeStack: UIStackView!
    @IBOutlet weak var funStack: UIStackView!
    @IBOutlet weak var recommendStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let blackStar = UIImage(named: "icStar0")
    let fillStar = UIImage(named: "icStar2")
    var clubactInfo: ClubActInfoModel!
    let starRatingModel = StarRatingViewModel()
    let disposeBag = DisposeBag()
    
    private var scrollAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1) {
            self.scrollView.transform = CGAffineTransform(scaleX: 1, y: 0)
        }
        
        bind(viewModel: starRatingModel)
        setupRateCalculate()
        
    }
    
    func scrollAppearAnim() {
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.alpha = 1
            self.scrollView.transform = .identity
        }
        scrollAppear = true
    }
    
    func bind(viewModel: StarRatingViewModel) {
        if let recommendStarButtons = recommendStack.subviews as? [UIButton] {
            viewModel
                .recommendDegreeObservable
                .filter { $0 != -1 }
                .distinctUntilChanged()
                .do(onNext: { [weak self] index in
                
                    if !(self?.scrollAppear ?? false) {
                        self?.scrollAppearAnim()
                    }
                    
                    recommendStarButtons
                        .forEach {$0.setImage(self?.blackStar, for: .normal)}
                })
                .subscribe(onNext: { [weak self] index in
                    
                    recommendStarButtons.filter { $0.tag <= index }
                        .forEach {
                            $0.setImage(self?.fillStar, for: .normal)
                            
                    }
                })
                .disposed(by: disposeBag)
        }
        
        if let funStarButtons = funStack.subviews as? [UIButton] {
            viewModel
                .funDegreeObservable
                .filter { $0 != -1 }
                .distinctUntilChanged()
                .do(onNext: { [weak self] _ in
                    funStarButtons.forEach { $0.setImage(self?.blackStar, for: .normal)}
                })
                .subscribe(onNext: { [weak self] index in
                    
                    funStarButtons
                        .filter { $0.tag <= index }
                        .forEach {
                            $0.setImage(self?.fillStar, for: .normal)
                            
                    }
                })
                .disposed(by: disposeBag)
        }
        
        if let proStarButtons = proDegreeStack.subviews as? [UIButton] {
            viewModel
                .proDegreeObservable
                .filter { $0 != -1 }
                .distinctUntilChanged()
                .do(onNext: { [weak self] _ in
                    proStarButtons.forEach { $0.setImage(self?.blackStar, for: .normal)}
                })
                .subscribe(onNext: { [weak self] index in
                    
                    proStarButtons.filter { $0.tag <= index }
                        .forEach {
                            $0.setImage(self?.fillStar, for: .normal)
                            
                    }
                })
                .disposed(by: disposeBag)
        }
        
        if let hardStarButtons = hardDegreeStack.subviews as? [UIButton] {
            viewModel
                .hardDegreeObservable
                .filter { $0 != -1 }
                .distinctUntilChanged()
                .do(onNext: { [weak self] _ in
                    hardStarButtons.forEach { $0.setImage(self?.blackStar, for: .normal)}
                })
                .subscribe(onNext: { [weak self] index in
                    
                    hardStarButtons.filter { $0.tag <= index }
                        .forEach {
                            $0.setImage(self?.fillStar, for: .normal)
                            
                    }
                })
                .disposed(by: disposeBag)
        }
        
        if let friendStarButtons = friendStack.subviews as? [UIButton] {
            viewModel
                .friendDegreeObservable
                .filter { $0 != -1 }
                .distinctUntilChanged()
                .do(onNext: { [weak self] _ in
                    friendStarButtons.forEach { $0.setImage(self?.blackStar, for: .normal)}
                })
                .subscribe(onNext: { [weak self] index in
                    
                    friendStarButtons.filter { $0.tag <= index }
                        .forEach {
                            $0.setImage(self?.fillStar, for: .normal)
                            
                    }
                })
                .disposed(by: disposeBag)
        }
        viewModel
            .nextButtonEnableObservable
            .distinctUntilChanged()
            .filter{ $0 }
            .subscribe(onNext: { [weak self] bool in
                self?.nextButton.isEnabled = bool
                self?.nextButton.backgroundColor = .cornFlower
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupRateCalculate() {
        var buttons = recommendStack.subviews as! [UIButton]
        buttons.forEach {$0.addTarget(self, action: #selector(recommendClick(sender:)), for: .touchUpInside)}
        
        buttons = funStack.subviews as! [UIButton]
        buttons.forEach {$0.addTarget(self, action: #selector(funcClick(sender:)), for: .touchUpInside)}
        
        buttons = proDegreeStack.subviews as! [UIButton]
        buttons.forEach {$0.addTarget(self, action: #selector(proClick(sender:)), for: .touchUpInside)}
        
        buttons = hardDegreeStack.subviews as! [UIButton]
        buttons.forEach {$0.addTarget(self, action: #selector(hardClick(sender:)), for: .touchUpInside)}
        
        buttons = friendStack.subviews as! [UIButton]
        buttons.forEach {$0.addTarget(self, action: #selector(friendClick(sender:)), for: .touchUpInside)}
    }
    
    @objc func recommendClick(sender: UIButton) {
        starRatingModel.recommendDegreeObservable.accept(sender.tag)
    }
    
    @objc func funcClick(sender: UIButton) {
        starRatingModel.funDegreeObservable.accept(sender.tag)
    }
    
    @objc func proClick(sender: UIButton) {
        starRatingModel.proDegreeObservable.accept(sender.tag)
    }
    
    @objc func hardClick(sender: UIButton) {
        starRatingModel.hardDegreeObservable.accept(sender.tag)
    }
    
    @objc func friendClick(sender: UIButton) {
        starRatingModel.friendDegreeObservable.accept(sender.tag)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SimpleReviewVC") as! SimpleReviewViewController
        
        clubactInfo.starRatingBind(model: starRatingModel)
        
        nextVC.clubactInfo = clubactInfo
        
        self.navigationController?.pushViewController(nextVC, animated: true)        
    }
}
