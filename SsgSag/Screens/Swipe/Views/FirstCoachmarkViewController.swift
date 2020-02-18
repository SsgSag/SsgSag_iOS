//
//  FirstCoachmarkViewController.swift
//  SsgSag
//
//  Created by bumslap on 18/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import FBSDKCoreKit

class FirstCoachmarkViewController: UIViewController {
    
    private let touchGesture = UIGestureRecognizer()
    var disposeBag = DisposeBag()
    var callback: (() -> Void)?
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Image"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(touchUpFilterButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .right
        label.text = "정보 추천 시스템이 업그레이드 되었어요.\n필터를 설정하고 필요한 정보만\n 슥-삭 받아보세요!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.431372549, blue: 0.9411764706, alpha: 0.5)
        view.addSubview(filterButton)
        view.addSubview(descriptionLabel)
        
        filterButton.topAnchor.constraint(
            equalTo: view.topAnchor, constant: -18).isActive = true
        filterButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: 50).isActive = true
        
        descriptionLabel.topAnchor.constraint(
            equalTo: filterButton.bottomAnchor,constant: 15).isActive = true
        descriptionLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,constant: -20).isActive = true
        descriptionLabel.widthAnchor.constraint(
            equalToConstant: 254).isActive = true
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

extension FirstCoachmarkViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        dismiss(animated: false)
        return true
    }
}
