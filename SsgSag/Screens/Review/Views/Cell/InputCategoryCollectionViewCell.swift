//
//  InputCategoryCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class InputCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 4
    }
    
    func bind(model: BehaviorRelay<[CategorySelectModel]>, item: Int) {
        categoryLabel.text = model.value[item].title
        print(model.value[item].onClick)
        if model.value[item].onClick {
            backGroundView.backgroundColor = .cornFlower
            categoryLabel.textColor = .white
        } else {
            backGroundView.backgroundColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
            categoryLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        }
    }

}
