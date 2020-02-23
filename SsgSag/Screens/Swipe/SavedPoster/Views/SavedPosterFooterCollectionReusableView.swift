//
//  SavedPosterFooterCollectionReusableView.swift
//  SsgSag
//
//  Created by  on 21/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SavedPosterFooterCollectionReusableView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "오늘의 추천정보는 유익하셨나요?"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icYes"), for: .normal)
        return button
    }()
    
    let dislikeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icNo"), for: .normal)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        
        likeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.dislikeButton.setImage(UIImage(named: "icNo"),
                                             for: .normal)
                self?.likeButton.setImage(UIImage(named: "icYesActive"),
                for: .normal)
                
            })
            .disposed(by: disposeBag)
        
        dislikeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.dislikeButton.setImage(UIImage(named: "icNoActive"),
                                         for: .normal)
                self?.likeButton.setImage(UIImage(named: "icYes"),
                                          for: .normal)
            
            })
            .disposed(by: disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpLayout() {
        addSubview(titleLabel)
        addSubview(buttonStackView)
        
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(dislikeButton)
        buttonStackView.addArrangedSubview(spaceView)
        buttonStackView.addArrangedSubview(likeButton)
        
        spaceView.widthAnchor.constraint(
            equalToConstant: 33).isActive = true
        
        titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: 63).isActive = true
        titleLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor, constant: -63).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(
            equalToConstant: 19).isActive = true
        
        buttonStackView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 13).isActive = true
        buttonStackView.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
    }
  
}
