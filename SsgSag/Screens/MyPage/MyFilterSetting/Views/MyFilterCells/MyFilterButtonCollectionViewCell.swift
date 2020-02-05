//
//  MyFilterCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MyFilterButtonCollectionViewCell: UICollectionViewCell, StoryboardView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(reactor: MyFilterButtonCollectionViewCellReactor) {
        reactor.state.map { $0.textColor }
            .subscribe(onNext: { [weak self] color in
                self?.titleLabel.textColor = color
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.backgroundColor }
            .subscribe(onNext: { [weak self] (color) in
                self?.contentView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.titleText }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}
