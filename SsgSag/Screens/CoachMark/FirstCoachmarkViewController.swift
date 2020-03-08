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
    var swipeDetailCallback: (() -> Void)?
    
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
    private var feedImageViewButtonBottomConstraint: NSLayoutConstraint?
    
    private let calendarImageViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "imgCoachmarkCalendar"),
                        for: .normal)
        return button
    }()
    private var calendarImageViewButtonBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
    }
    
    func bind(viewModel: CoachMarkViewModel) {
        setupLayout()
        
        //InPut
        viewModel
            .backgroundColor
            .asDriver()
            .drive(view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
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
        
        //OutPut
        swipeDescriptionButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: false) { [weak self] in
                    self?.swipeDetailCallback?()
                }
            })
            .disposed(by: disposeBag)
        
        let bottomDistance: CGFloat = 16
        switch viewModel.type {
        case .filtering:
            break
        case .swipeMain(let point):
            swipeDescriptionButtonTopConstraint?.constant = point.y
            swipeDescriptionButtonTopConstraint?.isActive = true
        case .feed(let point):
            feedImageViewButtonBottomConstraint?.constant = -(point.y
                + bottomDistance)
            feedImageViewButtonBottomConstraint?.isActive = true
        case .calendar(let point):
            calendarImageViewButtonBottomConstraint?.constant = -(point.y
                + bottomDistance)
            calendarImageViewButtonBottomConstraint?.isActive = true
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
        swipeDescriptionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 153).isActive = true
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
        
        feedImageViewButton.widthAnchor.constraint(
            equalToConstant: 234).isActive = true
        feedImageViewButton.heightAnchor.constraint(
            equalToConstant: 93).isActive = true
        feedImageViewButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 16).isActive = true
        feedImageViewButtonBottomConstraint = NSLayoutConstraint(item: feedImageViewButton,
                                                                 attribute: .bottom,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .bottom,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
        calendarImageViewButton.widthAnchor.constraint(
            equalToConstant: 232).isActive = true
        calendarImageViewButton.heightAnchor.constraint(
            equalToConstant: 93).isActive = true
        calendarImageViewButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -57).isActive = true
        calendarImageViewButtonBottomConstraint = NSLayoutConstraint(item: calendarImageViewButton,
                                                                 attribute: .bottom,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .bottom,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
        
    }
    
    func calculateDistance(by type: CoachMarkType) -> CGFloat {
        switch type {
        case .calendar:
            return .zero
        case .feed:
            return .zero
        default:
            return .zero
        }
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

