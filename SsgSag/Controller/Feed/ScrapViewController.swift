//
//  ScrapViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 23/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import AdBrixRM

class ScrapViewController: UIViewController {
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let feedService: FeedService
        = DependencyContainer.shared.getDependency(key: .feedService)
    
    private var feedData: [FeedData] = []
    private var feedTasks: [URLSessionTask?] = []
    private var currentPage: Int = 0
    var callback: (()->())?
    
    private lazy var scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_backFeed"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "북마크"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = backButton
        tabBarController?.tabBar.isHidden = true
//        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRequestScrap()
        setupLayout()
        setupCollectionView()
    }
    
    private func setupRequestScrap() {
        feedService.requestScrapList(page: currentPage) { [weak self] result in
            switch result {
            case .success(let feedDatas):
                self?.feedData = feedDatas
                
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
                
                DispatchQueue.main.async {
                    self?.scrapCollectionView.reloadData()
                }
            case .failed(let error):
                print(error)
                return
            }
        }
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
        callback?()
        navigationController?.popViewController(animated: true)
    }

}

extension ScrapViewController: UICollectionViewDelegate {
    
}

extension ScrapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return feedData.count == 0 ? 1 : feedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if feedData.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyScrapCell",
                                                                for: indexPath)
                as? EmptyScrapCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell",
                                                            for: indexPath)
            as? NewsCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        cell.feedData = feedData[indexPath.item]
        
        if feedData[indexPath.item].feedPreviewImgUrl == cell.feedData?.feedPreviewImgUrl {
            guard let urlString = feedData[indexPath.item].feedPreviewImgUrl else {
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
                            cell.newsImageView?.image = image
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
        if feedData.count == 0 {
            return
        }
        
        let adBrix = AdBrixRM.getInstance
        adBrix.event(eventName: "touchUp_FeedNews",
                     value: ["feedUrl": feedData[indexPath.item].feedUrl])
        
        let articleVC = ArticleViewController()
        articleVC.articleTitle = feedData[indexPath.item].feedName
        articleVC.articleUrlString = feedData[indexPath.item].feedUrl
        articleVC.feedIdx = feedData[indexPath.item].feedIdx
        articleVC.isSave = feedData[indexPath.item].isSave
        articleVC.callback = { [weak self] in
            self?.setupRequestScrap()
        }
        navigationController?.pushViewController(articleVC,
                                                 animated: true)
    }
}

extension ScrapViewController: UICollectionViewDataSourcePrefetching {
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

extension ScrapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if feedData.count == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: view.frame.width,
                      height: 220)
    }
}
