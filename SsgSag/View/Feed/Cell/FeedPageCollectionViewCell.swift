//
//  FeedPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol FeedTouchDelegate: class {
    func touchUpFeedCell(title: String, feedIdx: Int, urlString: String, isSave: Int)
}

class FeedPageCollectionViewCell: UICollectionViewCell {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private var isUpdating = false
    private var feedTasks: [URLSessionDataTask?] = []
    private var currentPage: Int = 0
    
    private let feedServiceImp: FeedService
        = DependencyContainer.shared.getDependency(key: .feedService)
    
    var lookAroundCallback: (()->())?
    var feedDatas: [FeedData] = []
    weak var delegate: FeedTouchDelegate?
    
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
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        requestFeed()
        setupLayout()
        setupCollectionView()
    }
    
    func requestFeed() {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        feedServiceImp.requestFeedData(page: currentPage) { [weak self] result in
            switch result {
            case .success(let feedDatas):
                self?.isUpdating = false
                
                if feedDatas.count == 0 {
                    return
                }
                
                self?.currentPage += 1
                
                for feedData in feedDatas {
                    guard let urlString = feedData.feedUrl,
                        let imageURL = URL(string: urlString) else {
                        self?.feedTasks.append(nil)
                        continue
                    }
                    
                    let dataTask
                        = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                        guard error == nil,
                            let data = data,
                            let image = UIImage(data: data) else {
                            return
                        }
                        
                        self?.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                    
                    self?.feedTasks.append(dataTask)
                }
                
                if self?.feedDatas.count == 0 {
                    self?.feedDatas = feedDatas

                    DispatchQueue.main.async {
                        self?.feedCollectionView.reloadData()
                        self?.refreshControl.endRefreshing()
                    }
                } else {
                    DispatchQueue.main.async {
                        feedDatas.forEach {
                            let indexPath = IndexPath(row: self?.feedDatas.count ?? 0, section: 0)
                            self?.feedDatas.append($0)
                            self?.feedCollectionView.insertItems(at: [indexPath])
                            self?.refreshControl.endRefreshing()
                        }
                    }
                }
            case .failed:
                self?.isUpdating = false
                return
            }
        }
    }
    
    private func requestScrap(_ feedIndex: Int, indexPath: IndexPath) {
        feedServiceImp.requestScrapStore(feedIndex: feedIndex) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    DispatchQueue.main.async {
                        guard let cell = self?.feedCollectionView.cellForItem(at: indexPath)
                            as? NewsCollectionViewCell else {
                            return
                        }
                        
                        self?.feedDatas[indexPath.item].isSave = 1
                        
                        cell.bookmarkButton.setImage(UIImage(named: "ic_bookmarkArticle"),
                                                     for: .normal)
                    }
                    print("스크랩 완료")
                    return
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("서버 에러")
                    return
                default:
                    print("저장 실패")
                    return
                }
            case .failed:
                assertionFailure()
                return
            }
        }
    }
    
    private func requestScrapDelete(_ feedIndex: Int, indexPath: IndexPath) {
        feedServiceImp.requestScrapDelete(feedIndex: feedIndex) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    DispatchQueue.main.async {
                        guard let cell = self?.feedCollectionView.cellForItem(at: indexPath)
                            as? NewsCollectionViewCell else {
                            return
                        }
                        
                        self?.feedDatas[indexPath.item].isSave = 0
                        
                        cell.bookmarkButton.setImage(UIImage(named: "ic_bookmarkArticlePassive"),
                                                     for: .normal)
                    }
                    print("스크랩 취소 완료")
                    return
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("서버 에러")
                    return
                default:
                    print("저장 실패")
                    return
                }
            case .failed:
                assertionFailure()
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
    
    @objc private func refresh() {
        currentPage = 0
        requestFeed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
            requestFeed()
        }
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
        cell.callback = { [weak self] feedIndex, status in
            guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
                return
            }
            
            guard !isTryWithoutLogin else {
                self?.lookAroundCallback?()
                return
            }
            
            if status == 0 {
                self?.requestScrap(feedIndex,
                                   indexPath: indexPath)
            } else {
                self?.requestScrapDelete(feedIndex,
                                         indexPath: indexPath)
            }
        }
        
        if feedDatas[indexPath.item].feedPreviewImgUrl == cell.feedData?.feedPreviewImgUrl {
            guard let urlString = feedDatas[indexPath.item].feedPreviewImgUrl else {
                return cell
            }
            
            if imageCache.object(forKey: urlString as NSString) == nil {
                if let imageURL = URL(string: urlString) {
                    
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        guard error == nil,
                            let data = data,
                            let image = UIImage(data: data) else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            cell.newsImageView.image = image
                        }
                    }.resume()
                }
                return cell
            }
            
            cell.newsImageView.image = imageCache.object(forKey: urlString as NSString)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let title = feedDatas[indexPath.item].feedName,
            let urlString = feedDatas[indexPath.item].feedUrl,
            let feedIdx = feedDatas[indexPath.item].feedIdx,
            let isSave = feedDatas[indexPath.item].isSave else {
            return
        }
        
        delegate?.touchUpFeedCell(title: title,
                                  feedIdx: feedIdx,
                                  urlString: urlString,
                                  isSave: isSave)
    }
}

extension FeedPageCollectionViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            feedTasks[$0.item]?.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            feedTasks[$0.item]?.cancel()
        }
    }
}

extension FeedPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width,
                      height: 220)
    }
}
