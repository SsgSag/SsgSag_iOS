//
//  RegisterCategoryCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class RegisterCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: ClubRegisterOneStepViewModel!
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(index: Int) {
        titleLabel.text = viewModel.categoryObservable.value[safe: index]
        self.index = index
    }
    
    @IBAction func deleteClick(_ sender: Any) {
        viewModel.deleteCategory(index: index)
    }
}
