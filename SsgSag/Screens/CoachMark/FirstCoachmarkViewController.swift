//
//  FirstCoachmarkViewController.swift
//  SsgSag
//
//  Created by bumslap on 18/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class FirstCoachmarkViewController: UIViewController {
    
    private let touchGesture = UIGestureRecognizer()
    var disposeBag = DisposeBag()
    var callback: (() -> Void)?
    
    private lazy var filteringFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Image"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(touchUpFilterButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let filteringDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .right
        label.text = "정보 추천 시스템이 업그레이드 되었어요.\n필터를 설정하고 필요한 정보만\n 슥-삭 받아보세요!"
        return label
    }()
    
    private let swipeDescriptionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "imgCoachmarkPoster"),
                        for: .normal)
        return button
    }()
    private var swipeDescriptionButtonTopConstraint: NSLayoutConstraint?
    
    
    private let swipeDetailImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "imgCoachmarkSwipe"),
                        for: .normal)
        return button
    }()
    
    private let feedImageViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "imgCoachmarkFeed"),
                        for: .normal)
        return button
    }()
    
    private let calendarImageViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "imgCoachmarkCalendar"),
                        for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    func bind(viewModel: CoachMarkViewModel) {
        
        
        viewModel
            .filteringButtonIsHidden
            .asDriver()
            .drive(filteringFilterButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .filteringDescriptionIsHidden
            .asDriver()
            .drive(filteringDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .swipeDescriptionIsHidden
            .asDriver()
            .drive(swipeDescriptionButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .swipeDetailImageViewIsHidden
            .asDriver()
            .drive(swipeDetailImageButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .feedImageViewIsHidden
            .asDriver()
            .drive(feedImageViewButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .calendarImageViewIsHidden
            .asDriver()
            .drive(calendarImageViewButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        switch viewModel.type {
        case .filtering:
            break
        case .swipeMain(let point):
            swipeDescriptionButtonTopConstraint?.constant = point.y
            swipeDescriptionButtonTopConstraint?.isActive = true
        default:
            break
        }
        
    }
    
    private func setupLayout() {
        let normalTabBarHeight: CGFloat = 49
        let tabBarHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + normalTabBarHeight
        
        view.addSubview(filteringFilterButton)
        view.addSubview(filteringDescriptionLabel)
        view.addSubview(swipeDescriptionButton)
        view.addSubview(swipeDetailImageButton)
        view.addSubview(feedImageViewButton)
        view.addSubview(calendarImageViewButton)
        
        filteringFilterButton.topAnchor.constraint(
            equalTo: view.topAnchor, constant: -18).isActive = true
        filteringFilterButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: 50).isActive = true
        
        filteringDescriptionLabel.topAnchor.constraint(
            equalTo: filteringFilterButton.bottomAnchor,constant: 15).isActive = true
        filteringDescriptionLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,constant: -20).isActive = true
        filteringDescriptionLabel.widthAnchor.constraint(
            equalToConstant: 254).isActive = true
        
        swipeDescriptionButton.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        swipeDescriptionButton.widthAnchor.constraint(
            equalToConstant: 166).isActive = true
        swipeDescriptionButton.heightAnchor.constraint(
            equalToConstant: 81).isActive = true
        swipeDescriptionButtonTopConstraint = NSLayoutConstraint(item: swipeDescriptionButton,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
        
        swipeDetailImageButton.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        swipeDetailImageButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -(tabBarHeight + 16)).isActive = true
        
    }
    
    @objc private func touchUpFilterButton(_: UIButton) {
        dismiss(animated: false) { [weak self] in
            self?.callback?()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dismiss(animated: false)
    }

}

