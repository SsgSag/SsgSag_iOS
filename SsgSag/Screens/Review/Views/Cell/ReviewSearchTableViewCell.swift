//
//  ReviewSearchTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewSearchTableViewCell: UITableViewCell {
    
    let categoryStack = CategoryList()
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func categoryFactory(labels: [String]) {
        self.addSubview(categoryStack)
        
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.heightAnchor.constraint(equalToConstant: 18).isActive = true
        categoryStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        categoryStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        categoryStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        
        labels.compactMap {
            let lable = CategoryView(text: $0)
            return lable
        }
        .forEach {
            categoryStack.addSubview($0)
        }
        self.layoutIfNeeded()
    }
    
    func bind(viewModel: ReviewSearchViewModel) {
        categoryFactory(labels: viewModel.cellModel)
    }
    
}
