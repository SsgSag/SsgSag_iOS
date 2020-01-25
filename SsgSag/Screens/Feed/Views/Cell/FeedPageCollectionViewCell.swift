//
//  FeedPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedPageCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    var lookAroundCallback: (()->())?
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        return refresh
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupCollectionView()
    }
    
    func bind(viewModel: FeedPageViewModel) {
        feedCollectionView
            .rx
            .contentOffset
            .withLatestFrom(viewModel.isLoading) { (offset: $0, isLoading: $1) }
            .filter { !$0.isLoading }
            .map { $0.offset.y }
            .filter { (($0 + self.feedCollectionView.frame.height) >= (self.feedCollectionView.contentSize.height - 100)) }
            .do(onNext: { [weak viewModel] (cellViewModels) in
                viewModel?.isLoading.accept(true)
            })
            .flatMapLatest { [weak viewModel] (_) -> Observable<[FeedData]> in
                guard let viewModel = viewModel else { return .empty() }
                return viewModel.fetchFeedPage()
            }
            .subscribe(onNext: { [weak viewModel] feeds in
                guard let viewModel = viewModel else { return }
                var addedViewModels = viewModel.newsCellViewModels.value
                addedViewModels.append(contentsOf: feeds.map { NewsCellViewModel(feed: $0) })
                viewModel.newsCellViewModels.accept(addedViewModels)
                viewModel.isLoading.accept(false)
                },
                       onError: { [weak viewModel] _ in
                viewModel?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
            
        viewModel.newsCellViewModels
            .bind(to: feedCollectionView
                .rx
                .items(cellIdentifier: "newsCell")
            ) { (indexPath, cellViewModel, cell) in
                guard let cell = cell as? NewsCollectionViewCell else { return }
                cell.bind(viewModel: cellViewModel)
            }
            .disposed(by: disposeBag)
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .filter { !viewModel.isLoading.value }
            .do(onNext: { [weak viewModel] in
                viewModel?.currentFeedPageNumber = 0
                viewModel?.isLoading.accept(true) })
            .flatMapLatest { return viewModel.fetchFeedPage() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak viewModel] feeds in
                viewModel?.newsCellViewModels.accept(feeds.map { NewsCellViewModel(feed: $0) })
                viewModel?.isLoading.accept(false)
                self?.refreshControl.endRefreshing()
                },
                       onError: { [weak self, weak viewModel] _ in
                viewModel?.isLoading.accept(false)
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
 
    private func setupLayout() {
        addSubview(feedCollectionView)
        
        feedCollectionView.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        feedCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        feedCollectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        feedCollectionView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        
    }
    
    private func setupCollectionView() {
        
        if #available(iOS 10.0, *) {
            feedCollectionView.refreshControl = refreshControl
        } else {
            feedCollectionView.addSubview(refreshControl)
        }
        
        let nibName = UINib(nibName: "NewsCollectionViewCell",
                            bundle: nil)
        
        feedCollectionView.register(nibName,
                                    forCellWithReuseIdentifier: "newsCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedPageCollectionViewCell: UICollectionViewDelegate {
}

extension FeedPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width,
                      height: 220)
    }
}
