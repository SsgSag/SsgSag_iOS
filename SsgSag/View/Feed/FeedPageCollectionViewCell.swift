//
//  FeedPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol FeedTouchDelegate: class {
    func touchUpFeedCell(title: String, urlString: String)
}

class FeedPageCollectionViewCell: UICollectionViewCell {
    
    private let feedServiceImp: FeedService
        = DependencyContainer.shared.getDependency(key: .feedService)
    
    var feedDatas: [FeedData] = []
    weak var delegate: FeedTouchDelegate?
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        return refresh
    }()
    
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
        setupCollectionView()
    }
    
    private func requestFeed() {
        feedServiceImp.requestFeedData { [weak self] result in
            switch result {
            case .success(let feedDatas):
                self?.feedDatas = feedDatas
                DispatchQueue.main.async {
                    self?.feedCollectionView.reloadData()
                    self?.refreshControl.endRefreshing()
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
        
    }
    
    private func setupCollectionView() {
        
        if #available(iOS 10.0, *) {
            feedCollectionView.refreshControl = refreshControl
        } else {
            feedCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        let nibName = UINib(nibName: "NewsCollectionViewCell",
                            bundle: nil)
        
        feedCollectionView.register(nibName,
                                    forCellWithReuseIdentifier: "newsCell")
    }
    
    @objc private func refresh(){
        requestFeed()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let title = feedDatas[indexPath.item].feedName,
            let urlString = feedDatas[indexPath.item].feedUrl else {
            return
        }
        
        delegate?.touchUpFeedCell(title: title,
                                  urlString: urlString)
    }
}

extension FeedPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 220)
    }
}
