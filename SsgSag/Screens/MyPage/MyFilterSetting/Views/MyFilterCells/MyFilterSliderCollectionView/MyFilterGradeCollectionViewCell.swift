//
//  MyFilterGradeCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 24/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MyFilterGradeCollectionViewCell: UICollectionViewCell, StoryboardView {
    
    typealias Reactor = MyFilterGradeCollectionViewCellReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(reactor: MyFilterGradeCollectionViewCellReactor) {
        
        //State
        reactor.state.map { $0.gradeTextColor }
            .subscribe(onNext: { [weak self] (color) in
                self?.gradeLabel.textColor = color
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gradeText }
            .bind(to: gradeLabel.rx.text)
            .disposed(by: disposeBag)
    
    }
}
