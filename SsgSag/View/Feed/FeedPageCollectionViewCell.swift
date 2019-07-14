//
//  FeedPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class FeedPageCollectionViewCell: UICollectionViewCell {
    
    lazy var feedCollectionView: UICollectionView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupLayout()
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
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell",
                                                 for: indexPath)
                as? NewsCollectionViewCell else {
                    return .init()
        }
        return cell
    }
}

extension FeedPageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
}
