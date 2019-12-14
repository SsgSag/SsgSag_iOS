//
//  TotalInformationCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 08/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class TotalInformationCollectionViewCell: UICollectionViewCell, StoryboardView {
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        setRadiusAndShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
   func setRadiusAndShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
       
    func bind(reactor: TotalInformationCollectionViewCellReactor) {
        reactor.state.map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.day }
            .filter{
                !$0.isEmpty
            }
            .do(onNext: { [weak self] string in
                guard let self = self else { return }
                let labelWidth = string.estimatedFrame(font: UIFont.systemFont(ofSize: 12, weight: .regular)).width
                self.dDayLabel.widthAnchor.constraint(
                    equalToConstant:  labelWidth + 10
                ).isActive = true
            })
            .bind(to: dDayLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hashTags }
            .bind(to: hashTagLabel.rx.text)
            .disposed(by: disposeBag)
                
        reactor.state.map { $0.thumbnailImage }
            .bind(to: thumbnailImageView.rx.image )
            .disposed(by: disposeBag)
    }
}
