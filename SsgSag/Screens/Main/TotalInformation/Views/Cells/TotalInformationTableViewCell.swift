//
//  TotalInformationTableViewCell.swift
//  SsgSag
//
//  Created by bumslap on 08/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class TotalInformationTableViewCell: UITableViewCell, StoryboardView {

    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(reactor: TotalInformationTableViewCellReactor) {
        //State
        reactor.state.map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.items }
            .bind(to: itemCollectionView.rx.items(cellIdentifier: "TotalInformationCollectionViewCell"))
            { indexPath, item, cell in
                guard let cell = cell as? TotalInformationCollectionViewCell else { return }
                cell.reactor = TotalInformationCollectionViewCellReactor(title: item.posterName ?? "",
                                                                         thumbnailImageUrl: item.thumbPhotoUrl ?? "",
                                                                         hashTags: item.keyword ?? "")
                
                Observable.just(())
                    .map { _ in TotalInformationCollectionViewCellReactor.Action.set(item) }
                    .bind(to: cell.reactor!.action).disposed(by: cell.disposeBag)
                
                Observable.just(())
                    .map { _ in TotalInformationCollectionViewCellReactor.Action.requestImage }
                    .bind(to: cell.reactor!.action).disposed(by: cell.disposeBag)
                
        }
        .disposed(by: disposeBag)
        
        //Action
        moreButton.rx.tap
            .map { _ in Reactor.Action.moreButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

      
        
    }

}
