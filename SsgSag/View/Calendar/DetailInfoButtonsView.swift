//
//  DetailInfoButtonsView.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import AdBrixRM

protocol WebsiteDelegate: class {
    func moveToWebsite(isApply: Bool)
}

protocol CommentWriteDelegate: class {
    func commentRegister(text: String)
}

class DetailInfoButtonsView: UIView {
    
    private let posterService: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    var callback: (() -> ())?
    weak var delegate: WebsiteDelegate?
    weak var commentDelegate: CommentWriteDelegate?
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
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return view
    }()
    
    private let commentWriteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    private let commentWriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "댓글을 입력해주세요"
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(touchUpRegisterButton), for: .touchUpInside)
        return button
    }()
    
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
    
    private let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        return view
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
        
        commentWriteStackView.addArrangedSubview(commentTextField)
        commentWriteStackView.addArrangedSubview(registerButton)
        
        commentWriteView.addSubview(commentWriteStackView)
        buttonView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(moveToWebSiteButton)
        buttonStackView.addArrangedSubview(applyButton)
        
        bottomStackView.addArrangedSubview(lineView)
        bottomStackView.addArrangedSubview(commentWriteView)
        bottomStackView.addArrangedSubview(buttonView)
        
        addSubview(bottomStackView)
        
        bottomStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        likeButton.widthAnchor.constraint(
            equalToConstant: 46).isActive = true
        likeButton.heightAnchor.constraint(
            equalToConstant: 46).isActive = true
        
        commentWriteView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        commentWriteView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        commentWriteView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        
        commentWriteStackView.leadingAnchor.constraint(equalTo: commentWriteView.leadingAnchor, constant: 18).isActive = true
        commentWriteStackView.trailingAnchor.constraint(equalTo: commentWriteView.trailingAnchor, constant: -18).isActive = true
        commentWriteStackView.centerYAnchor.constraint(equalTo: commentWriteView.centerYAnchor).isActive = true
        
        registerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        buttonView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        buttonView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        
        buttonStackView.leadingAnchor.constraint(
            equalTo: buttonView.leadingAnchor, constant: 12).isActive = true
        buttonStackView.trailingAnchor.constraint(
            equalTo: buttonView.trailingAnchor, constant: -12).isActive = true
    }
    
    @objc private func touchUpWebSiteButton() {
        delegate?.moveToWebsite(isApply: false)
    }
    
    @objc private func touchUpApplyButton() {
        delegate?.moveToWebsite(isApply: true)
    }
    
    @objc private func touchUpLikeButton(_ sender: UIButton) {
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool,
            !isTryWithoutLogin else {
                return
        }
        
        let method: HTTPMethod = isLike == 1 ? .delete : .post
        
        guard let index = posterIndex else {
            return
        }
        
        let adBrix = AdBrixRM.getInstance
        adBrix.event(eventName: "touchUp_Favorite")
        
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
    
    @objc func touchUpRegisterButton() {
        //TODO: 댓글 등록 및 재로드 로직 추가
        if commentTextField.text == "" {
            return
        }
        
        commentDelegate?.commentRegister(text: commentTextField.text ?? "")
        commentTextField.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
