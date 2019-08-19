//
//  DetailInfoButtonsView.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol WebsiteDelegate: class {
    func moveToWebsite(isApply: Bool)
}

class DetailInfoButtonsView: UIView {

    private let posterService: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    var callback: (() -> ())?
    var delegate: WebsiteDelegate?
    var posterIndex: Int?
    var isExistApplyURL: Bool? {
        didSet {
            guard let isExist = self.isExistApplyURL else {
                return
            }
            
            if isExist {
                DispatchQueue.main.async {
                    self.applyButton.isUserInteractionEnabled = true
                    self.applyButton.alpha = 1
                }
            } else {
                DispatchQueue.main.async {
                    self.applyButton.isUserInteractionEnabled = false
                    self.applyButton.alpha = 0.2
                }
            }
        }
    }
    
    var isLike: Int? {
        didSet {
            if isLike == 1 {
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(named: "ic_favoriteWhiteBox"),
                                             for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(named: "ic_favoriteWhiteBoxPassive"),
                                             for: .normal)
                }
            }
        }
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(touchUpLikeButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var moveToWebSiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("웹사이트", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(touchUpWebSiteButton),
                         for: .touchUpInside)
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("바로지원", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(touchUpApplyButton),
                         for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
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
        delegate?.moveToWebsite(isApply: false)
    }
    
    @objc private func touchUpApplyButton() {
        delegate?.moveToWebsite(isApply: true)
    }
    
    @objc private func touchUpLikeButton(_ sender: UIButton) {
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool,
            isTryWithoutLogin else {
                return
        }
        
        let method: HTTPMethod = isLike == 1 ? .delete : .post
        
        guard let index = posterIndex else {
            return
        }
        
        posterService.requestPosterFavorite(index: index,
                                            method: method) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .processingSuccess:
                    DispatchQueue.main.async {
                        if sender.imageView?.image == UIImage(named: "ic_favoriteWhiteBoxPassive") {
                            sender.setImage(UIImage(named: "ic_favoriteWhiteBox"),
                                            for: .normal)
                            self?.isLike = 1
                        } else {
                            sender.setImage(UIImage(named: "ic_favoriteWhiteBoxPassive"),
                                            for: .normal)
                            self?.isLike = 0
                        }
                        
                        self?.callback?()
                    }
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("server 에러")
                default:
                    return
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
