//
//  MyClubTableViewCell.swift
//  SsgSag
//
//  Created by bumslap on 07/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyClubTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clubTypebackgroundView: UIView!
    @IBOutlet weak var clubTypeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var approvalLabel: UILabel!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clubTypebackgroundView.backgroundColor = UIColor.cornFlower.withAlphaComponent(0.08)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    func bind(viewModel: MyClubCellViewModel) {
        viewModel
            .clubTypeText
            .asDriver()
            .drive(clubTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .titleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .dateText
            .asDriver()
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .approvalText
            .asDriver()
            .drive(approvalLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
