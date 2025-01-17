//
//  ScrapViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 23/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
//import AdBrixRM
import RxSwift
import RxCocoa

class ScrapViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    private lazy var scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_backFeed"),
                                                  style: .plain,
                                                  target: self,
                                                  action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "북마크"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = backButton
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupCollectionView()
    }
    
    func bind(viewModel: FeedPageViewModel) {
        scrapCollectionView
            .rx
            .contentOffset
            .withLatestFrom(viewModel.isLoading) { (offset: $0, isLoading: $1) }
            .filter { !$0.isLoading }
            .map { $0.offset.y }
            .filter { (($0 + self.scrapCollectionView.frame.height) >= (self.scrapCollectionView.contentSize.height - 100)) }
            .do(onNext: { [weak viewModel] (cellViewModels) in
                viewModel?.isLoading.accept(true)
            })
            .flatMapLatest { [weak viewModel] (_) -> Observable<[FeedData]> in
                guard let viewModel = viewModel else { return .empty() }
                return viewModel.fetchScrapedFeedPage()
            }
            .subscribe(onNext: { [weak viewModel] feeds in
                guard let viewModel = viewModel else { return }
                var addedViewModels = viewModel.newsCellViewModels.value
                addedViewModels.append(contentsOf: feeds.map { NewsCellViewModel(feed: $0) })
                viewModel.newsCellViewModels.accept(addedViewModels)
                viewModel.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
            
        viewModel.newsCellViewModels
            .bind(to: scrapCollectionView
                .rx
                .items(cellIdentifier: "newsCell")
            ) { (indexPath, cellViewModel, cell) in
                guard let cell = cell as? NewsCollectionViewCell else { return }
                cell.bind(viewModel: cellViewModel)
            }
            .disposed(by: disposeBag)
        
        scrapCollectionView
            .rx
            .itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak viewModel] indexPath in
                guard let feed = viewModel?
                    .newsCellViewModels
                    .value[indexPath.item].feed else {
                    return
                }
                let articleVC = ArticleViewController()
                articleVC.articleTitle = feed.feedName
                articleVC.articleUrlString = feed.feedUrl
                articleVC.feedIdx = feed.feedIdx
                articleVC.isSave = feed.isSave
                self?.navigationController?.pushViewController(articleVC,
                                                               animated: true)
            })
            .disposed(by: disposeBag)
        
        backButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(scrapCollectionView)
        
        scrapCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrapCollectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrapCollectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrapCollectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let newsNib = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        
        scrapCollectionView.register(newsNib,
                                     forCellWithReuseIdentifier: "newsCell")
        
        scrapCollectionView.register(EmptyScrapCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "emptyScrapCell")
    }
    
    @objc private func touchUpBackButton() {
//        callback?()
        navigationController?.popViewController(animated: true)
    }

}

extension ScrapViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,
                      height: 220)
    }
}
