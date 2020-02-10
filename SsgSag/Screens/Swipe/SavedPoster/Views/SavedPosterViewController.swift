//
//  SavedPosterViewController.swift
//  SsgSag
//
//  Created by bumslap on 09/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private enum Section: Int {
    case like
    case dislike
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
    
}

class SavedPosterViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var savedPosterCollectionView: UICollectionView!
    var viewModel: SavedPosterViewModel?
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                       style: .plain,
                                                       target: self,
                                                       action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        let viewModel = SavedPosterViewModel()
        bind(viewModel: viewModel)
        title = "오늘의 슥삭"
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setUpCollectionView() {
        let allposterNib = UINib(nibName: "AllPosterListCollectionViewCell", bundle: nil)
               
        savedPosterCollectionView.register(allposterNib,
                                           forCellWithReuseIdentifier: "allPosterListCell")
        savedPosterCollectionView.dataSource = self
        savedPosterCollectionView.delegate = self
    }
    
    func bind(viewModel: SavedPosterViewModel) {
        self.viewModel = viewModel
        viewModel.buildCellViewModels()
        
        viewModel
            .cellViewModels
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] cellViewModel in
                self?.savedPosterCollectionView.reloadData()
            })
        .disposed(by: disposeBag)
        
        backButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension SavedPosterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let section = Section(section: section)
        switch section {
        case .like:
            return viewModel.cellViewModels.value.filter { $0.isLiked }.count
        case .dislike:
            return viewModel.cellViewModels.value.filter { !$0.isLiked }.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return .init() }
        let poster = viewModel.cellViewModels.value[indexPath.item].poster
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "allPosterListCell",
                                 for: indexPath) as? AllPosterListCollectionViewCell else { return .init() }
        cell.posterData = PosterDataAfterSwpie(posterIdx: poster.posterIdx, categoryIdx: poster.categoryIdx, subCategoryIdx: poster.subCategoryIdx, photoUrl: poster.photoUrl, thumbPhotoUrl: poster.photoUrl, posterName: poster.posterName, posterRegDate: poster.posterRegDate, posterStartDate: poster.posterStartDate, posterEndDate: poster.posterEndDate, documentDate: poster.documentDate, contentIdx: poster.contentIdx, keyword: poster.keyword, favoriteNum: poster.favoriteNum, likeNum: poster.likeNum, swipeNum: 1, isSave: 0, dday: poster.dday)
        return cell
        
    }
    
    
}

extension SavedPosterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 94)
    }
}
