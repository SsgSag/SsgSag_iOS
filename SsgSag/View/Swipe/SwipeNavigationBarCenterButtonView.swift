//
//  SwipeNavigationBarCenterButtonView.swift
//  SsgSag
//
//  Created by bumslap on 01/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum TitleButtonType {
    case total
    case recommend
}

class SwipeNavigationBarCenterButtonView: UIView {
    @IBOutlet weak var totalViewButton: UIButton!
    @IBOutlet weak var recommendViewButton: UIButton!
    
    @IBAction func recommendButtonDidTap(_ sender: Any) {
        userpressed(type: .recommend)
    }

    @IBAction func totalButtonDidTap(_ sender: Any) {
         userpressed(type: .total)
    }
    
    var recommendViewButtonHandler: (() -> Void)?
    var totalViewButtonnHandler: (() -> Void)?
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }

    func userpressed(type: TitleButtonType) {
        switch type {
        case .total:
            totalViewButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
            totalViewButton.setTitleColor(.cornFlower, for: .normal)
            recommendViewButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
            recommendViewButton.setTitleColor(.unselectedTextGray, for: .normal)
            totalViewButtonnHandler?()
        case .recommend:
             recommendViewButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
             recommendViewButton.setTitleColor(.cornFlower, for: .normal)
             totalViewButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
             totalViewButton.setTitleColor(.unselectedTextGray, for: .normal)
             recommendViewButtonHandler?()
        }
    }
}
