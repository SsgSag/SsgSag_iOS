//
//  FeedPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class FeedPageCollectionViewCell: UICollectionViewCell {
    
    private let feedServiceImp: FeedService
        = DependencyContainer.shared.getDependency(key: .feedService)
    
    var feedDatas: [FeedData] = []
    
    lazy var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        requestFeed()
        setupLayout()
    }
    
    private func requestFeed() {
        feedServiceImp.requestFeedData { [weak self] result in
            switch result {
            case .success(let feedDatas):
                self?.feedDatas = feedDatas
                DispatchQueue.main.async {
                    self?.feedCollectionView.reloadData()
                }
            case .failed(let error):
                print(error)
                return
            }
        }
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

extension FeedPageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return feedDatas.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell",
                                                 for: indexPath)
                as? NewsCollectionViewCell else {
                    return .init()
        }
        
        cell.feedData = feedDatas[indexPath.item]
        
        if feedDatas[indexPath.item].feedPreviewImgUrl == cell.feedData?.feedPreviewImgUrl {
            let imageURL = feedDatas[indexPath.item].feedPreviewImgUrl ?? ""
            guard let url = URL(string: imageURL) else {
                return cell
            }
            
            ImageNetworkManager.shared.getImageByCache(imageURL: url) { (image, error) in
                if error == nil {
                    cell.newsImageView.image = image
                }
            }
        }
        
        
        return cell
    }
}

extension FeedPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 190)
    }
}
