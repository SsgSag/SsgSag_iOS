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

private enum Section: Int, CaseIterable {
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
    
    @IBOutlet weak var moveToCalendarButton: UIButton!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUpCollectionView() {
        let allposterNib = UINib(nibName: "AllPosterListCollectionViewCell", bundle: nil)
        savedPosterCollectionView.register(allposterNib,
                                           forCellWithReuseIdentifier: "allPosterListCell")
        
        savedPosterCollectionView.register(SavedPosterCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                            withReuseIdentifier: "SavedPosterCollectionReusableView")
        
        savedPosterCollectionView.register(SavedPosterFooterCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                           withReuseIdentifier: "SavedPosterFooterCollectionReusableView")


        savedPosterCollectionView.dataSource = self
        savedPosterCollectionView.delegate = self
    }
    
    func bind(viewModel: SavedPosterViewModel) {
        self.viewModel = viewModel
        viewModel.buildCellViewModels {
            DispatchQueue.main.async { [weak self] in
                self?.savedPosterCollectionView.reloadData()
            }
        }
        
        backButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        moveToCalendarButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.tabBarController?.tabBar.isHidden = false
                self?.navigationController?.tabBarController?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
        
        savedPosterCollectionView
            .rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [weak self, weak viewModel] indexPath in
                guard let viewModel = viewModel else { return }
                let detailInfoVC = DetailInfoViewController()
                let section = Section(at: indexPath)
                switch section {
                case .like:
                   detailInfoVC.posterIdx = viewModel.favoritCellViewModels[indexPath.item].poster.posterIdx
                   detailInfoVC.isSave = viewModel.favoritCellViewModels[indexPath.item].poster.isSave ?? 0
                case .dislike:
                    detailInfoVC.posterIdx = viewModel.disLikeCellViewModels[indexPath.item].poster.posterIdx
                    detailInfoVC.isSave = viewModel.disLikeCellViewModels[indexPath.item].poster.isSave ?? 0
                }
                detailInfoVC.isCalendar = false
                self?.navigationController?.pushViewController(detailInfoVC, animated: true)
            
            })
            .disposed(by: disposeBag)
    }
}

extension SavedPosterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let section = Section(section: section)
        switch section {
        case .like:
            return viewModel.favoritCellViewModels.count
        case .dislike:
            return viewModel.disLikeCellViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return .init() }
        
        let section = Section(at: indexPath)
        guard let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "allPosterListCell",
                             for: indexPath) as? AllPosterListCollectionViewCell else { return .init() }
        
        switch section {
        case .like:
            let poster = viewModel.favoritCellViewModels[indexPath.item].poster
            cell.posterData = PosterDataAfterSwipe(posterIdx: poster.posterIdx,
                                                   categoryIdx: poster.categoryIdx,
                                                   subCategoryIdx: poster.subCategoryIdx,
                                                   photoUrl: poster.photoUrl,
                                                   thumbPhotoUrl: poster.thumbPhotoUrl,
                                                   posterName: poster.posterName,
                                                   posterRegDate: poster.posterRegDate,
                                                   posterStartDate: poster.posterStartDate,
                                                   posterEndDate: poster.posterEndDate,
                                                   documentDate: poster.documentDate,
                                                   contentIdx: poster.contentIdx,
                                                   keyword: poster.keyword,
                                                   favoriteNum: poster.favoriteNum,
                                                   likeNum: poster.likeNum,
                                                   swipeNum: poster.swipeNum,
                                                   isSave: poster.isSave,
                                                   dday: poster.dday)
            return cell
        case .dislike:
            let poster = viewModel.disLikeCellViewModels[indexPath.item].poster
            cell.posterData = PosterDataAfterSwipe(posterIdx: poster.posterIdx,
                                                   categoryIdx: poster.categoryIdx,
                                                   subCategoryIdx: poster.subCategoryIdx,
                                                   photoUrl: poster.photoUrl,
                                                   thumbPhotoUrl: poster.thumbPhotoUrl,
                                                   posterName: poster.posterName,
                                                   posterRegDate: poster.posterRegDate,
                                                   posterStartDate: poster.posterStartDate,
                                                   posterEndDate: poster.posterEndDate,
                                                   documentDate: poster.documentDate,
                                                   contentIdx: poster.contentIdx,
                                                   keyword: poster.keyword,
                                                   favoriteNum: poster.favoriteNum,
                                                   likeNum: poster.likeNum,
                                                   swipeNum: poster.swipeNum,
                                                   isSave: poster.isSave,
                                                   dday: poster.dday)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel else { return .init() }
        
        
        
//        guard let emptyView = collectionView
//        .dequeueReusableSupplementaryView(ofKind: kind,
//                                          withReuseIdentifier: "CollectionReusableView",
//                                          for: indexPath) as? UICollectionReusableView else { return .init()
//        }
        
        let section = Section(at: indexPath)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch section {
            case .like:
               if viewModel.favoritCellViewModels.isEmpty {
                return .init()
               }
               guard let header = collectionView
                   .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                     withReuseIdentifier: "SavedPosterCollectionReusableView",
                                                     for: indexPath) as? SavedPosterCollectionReusableView else { return .init()
               }
               header.titleLabel.text = "오늘 슥 - 저장한 정보👆"
               return header
            case .dislike:
                if viewModel.disLikeCellViewModels.isEmpty {
                    return .init()
                }
                guard let header = collectionView
                    .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                      withReuseIdentifier: "SavedPosterCollectionReusableView",
                                                      for: indexPath) as? SavedPosterCollectionReusableView else { return .init()
                }
                header.titleLabel.text = "오늘 삭- 삭제한 정보👇🏾"
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            switch section {
            case .like:
                return .init()
            case .dislike:
                guard let footer = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                  withReuseIdentifier: "SavedPosterFooterCollectionReusableView",
                                                  for: indexPath) as? SavedPosterFooterCollectionReusableView else { return .init()
                }
                return footer
            }
        default:
            return .init()
        }
    }
}

extension SavedPosterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 30, height: 94)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(section: section)
        
        switch section {
        case .like:
            return .init(top: 20, left: 0, bottom: 49, right: 0)
        case .dislike:
            return .init(top: 20, left: 0, bottom: 41, right: 0)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        let section = Section(section: section)
        
        switch section {
        case .like:
            if viewModel.favoritCellViewModels.isEmpty {
                return .zero
            }
            return .init(width: collectionView.frame.width, height: 28)
        case .dislike:
            if viewModel.disLikeCellViewModels.isEmpty {
                return .zero
            }
            return .init(width: collectionView.frame.width, height: 28)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        let section = Section(section: section)
        
        switch section {
        case .like:
            return .zero
        case .dislike:
            if viewModel.favoritCellViewModels.isEmpty
                && viewModel.disLikeCellViewModels.isEmpty {
                return .zero
            }
            return .init(width: collectionView.frame.width, height: 120)
        }
        
    }
}
