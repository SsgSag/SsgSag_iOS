//
//  DetailInfoButtonsView.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol WebsiteDelegate: class {
    func moveToWebsite()
}

class DetailInfoButtonsView: UIView {

    var delegate: WebsiteDelegate?
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_favoriteWhiteBoxPassive"), for: .normal)
        return button
    }()
    
    lazy var moveToWebSiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("웹사이트", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(touchUpWebSiteButton),
                         for: .touchUpInside)
        return button
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("바로지원", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.alpha = 0.2
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(moveToWebSiteButton)
        buttonStackView.addArrangedSubview(applyButton)
        
        addSubview(buttonStackView)
        
        likeButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    @objc private func touchUpWebSiteButton() {
        delegate?.moveToWebsite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
