//
//  NoTodoHeaderView.swift
//  SsgSag
//
//  Created by 이혜주 on 02/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NoTodoHeaderView: UIView {

    let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이날은 일정이 없네요.\n슥삭하러 가볼까요?"
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(noticeLabel)
        
        noticeLabel.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        noticeLabel.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
