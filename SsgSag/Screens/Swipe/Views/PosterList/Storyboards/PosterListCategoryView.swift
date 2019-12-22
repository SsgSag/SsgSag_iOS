//
//  PosterListCategoryView.swift
//  SsgSag
//
//  Created by bumslap on 21/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PosterListCategoryView: UIView {
    var disposeBag = DisposeBag()
    @IBOutlet weak var posterListCategoryCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRadiusAndShadow()
        setUpUiComponnents()
    }
    
    func bind(viewModel: PosterListCategoryViewModel) {
        Observable.of(viewModel.cellViewModels)
            .bind(to:
            posterListCategoryCollectionView.rx.items(cellIdentifier: "PosterListCategoryCollectionViewCell")){
                indexPath, cellViewModel, cell  in
                let cell = cell as? PosterListCategoryCollectionViewCell
                cell?.bind(viewModel: cellViewModel)
        }
        .disposed(by: disposeBag)

    }
    
    func setRadiusAndShadow() {
        posterListCategoryCollectionView.layer.shadowColor = UIColor.lightGray.cgColor
        posterListCategoryCollectionView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        posterListCategoryCollectionView.layer.shadowRadius = 6.0
        posterListCategoryCollectionView.layer.shadowOpacity = 0.2
        posterListCategoryCollectionView.layer.masksToBounds = false
    }
    
    func setUpUiComponnents() {
        posterListCategoryCollectionView.delegate = self
        let cellNib = UINib(nibName: "PosterListCategoryCollectionViewCell", bundle: nil)
        posterListCategoryCollectionView.register(cellNib,
                                                  forCellWithReuseIdentifier: "PosterListCategoryCollectionViewCell")
        
        let layout = posterListCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = .init(top: 0, left: 30, bottom: 0, right: 0)
        layout?.minimumInteritemSpacing = 88
        layout?.minimumLineSpacing = 16
    }
}

extension PosterListCategoryView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = indexPath.item == 0 ? collectionView.bounds.width : 80
        return .init(width: cellWidth, height: 16)
    }
}
