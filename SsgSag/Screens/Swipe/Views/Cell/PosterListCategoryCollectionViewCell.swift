//
//  PosterListCategoryCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 21/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

class PosterListCategoryCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var titleLabel: UILabel!
    
    func bind(viewModel: PosterListCategoryCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        
        viewModel.titleColor
            .subscribe(onNext: { [weak self] color in
                self?.titleLabel.textColor = color
            })
            .disposed(by: disposeBag)
    }
}
