//
//  IntroPageCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 10/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class IntroPageCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var introTitleImageView: UIImageView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var startAppStackView: UIStackView!
    @IBOutlet weak var pageControlImageStackView: UIStackView!
    
    lazy var recognizer = UITapGestureRecognizer(target: self, action: nil)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        backgroundImageView.image = nil
        introTitleImageView.image = nil
        introLabel.text = ""
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColorView.backgroundColor = UIColor.cornFlowerLight.withAlphaComponent(0.6)
        
        startAppStackView.addGestureRecognizer(recognizer)
    }
    
    func bind(viewModel: IntroPageCellViewModel) {
        viewModel
            .backgroundImageString
            .asDriver()
            .drive(onNext: { [weak self] string in
                self?.backgroundImageView.image = UIImage(named: string)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .introTitleImageString
            .asDriver()
            .drive(onNext: { [weak self] string in
                self?.introTitleImageView.image = UIImage(named: string)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .introString
            .asDriver()
            .drive(onNext: { [weak self] text in
                self?.introLabel.text = text
            })
            .disposed(by: disposeBag)
        
        viewModel
            .isStartAppStackViewHidden
            .asDriver()
            .drive(onNext: { [weak self] isHidden in
                self?.startAppStackView.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        recognizer
            .rx
            .event
            .asDriver()
            .drive(onNext: { [weak viewModel] _ in
                viewModel?.userPressedStartButton()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .pageDotAlphaArray
            .asDriver()
            .drive(onNext: { [weak self] alphaArray in
                self?.pageControlImageStackView.arrangedSubviews
                    .enumerated()
                    .forEach {
                        $0.element.alpha = alphaArray[safe: $0.offset] ?? 0
                }
            })
            .disposed(by: disposeBag)
    }
}
