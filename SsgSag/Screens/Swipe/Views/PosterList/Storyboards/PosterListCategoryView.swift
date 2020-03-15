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
    @IBOutlet weak var posterListCategoryCollectionView: UICollectionView?

    @IBOutlet weak var firstCategoryButton: UIButton!
    @IBOutlet weak var secondCategoryButton: UIButton!
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: PosterListCategoryViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUiComponnents()
        posterListCategoryCollectionView?.dataSource = self
    }
    
    func bind(viewModel: PosterListCategoryViewModel) {
        self.viewModel = viewModel
        guard let posterListCategoryCollectionView = self.posterListCategoryCollectionView else { return }
        
        if viewModel.headerCategories.isEmpty {
            buttonViewHeightConstraint.constant = 0
        } else {
            buttonViewHeightConstraint.constant = 32
        }
        
        viewModel.headerCategories.forEach {
            switch $0 {
            case .allClub(let title):
                secondCategoryButton.setTitle(title, for: .normal)
            case .internalClub(let title):
                firstCategoryButton.setTitle(title, for: .normal)
            case .internshipCompanyType(let title):
                    firstCategoryButton.setTitle(title, for: .normal)
            case .internshipInteresting(let title):
                    secondCategoryButton.setTitle(title, for: .normal)
            default:
                break
            }
        }
        
        viewModel
            .firstButtonTitleColor
            .asDriver()
            .drive(onNext: { [weak self] color in
                self?.firstCategoryButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .secondButtonTitleColor
            .asDriver()
            .drive(onNext: { [weak self] color in
                self?.secondCategoryButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .firstButtonBackgroundColor
            .asDriver()
            .drive(firstCategoryButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel
            .secondButtonBackgroundColor
            .asDriver()
            .drive(secondCategoryButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel
            .cellViewModels
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.posterListCategoryCollectionView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        firstCategoryButton
            .rx
            .tap
            .subscribe(onNext: { [weak viewModel] _ in
                viewModel?.userPressed(at: 0)
            })
            .disposed(by: disposeBag)
        
        secondCategoryButton
            .rx
            .tap
            .subscribe(onNext: { [weak viewModel] _ in
                viewModel?.userPressed(at: 1)
            })
            .disposed(by: disposeBag)

    }
    
    func setUpUiComponnents() {
        
        posterListCategoryCollectionView?.delegate = self
        let cellNib = UINib(nibName: "PosterListCategoryCollectionViewCell", bundle: nil)
        posterListCategoryCollectionView?.register(cellNib,
                                                  forCellWithReuseIdentifier: "PosterListCategoryCollectionViewCell")
        
        let layout = posterListCategoryCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = .init(top: 0, left: 30, bottom: 0, right: 0)
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 16
    }
}

extension PosterListCategoryView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = indexPath.item == 0 ? collectionView.bounds.width : (collectionView.bounds.width / 2) - 16
        return .init(width: cellWidth, height: 16)
    }
}

extension PosterListCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
       return viewModel?.cellViewModels.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterListCategoryCollectionViewCell",
                                                            for: indexPath) as? PosterListCategoryCollectionViewCell else {
                                                                return .init()
        }
        if let cellVM = viewModel?.cellViewModels.value[safe: indexPath.item] {
            cell.bind(viewModel: cellVM)
        }
        return cell
    }
}
