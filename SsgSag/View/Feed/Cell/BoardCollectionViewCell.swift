//
//  BoardCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    
    lazy var boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
        addSubview(boardCollectionView)
        
        boardCollectionView.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        boardCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        boardCollectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        boardCollectionView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        
        let nibName = UINib(nibName: "BoardPostCollectionViewCell",
                            bundle: nil)
        
        boardCollectionView.register(nibName,
                                    forCellWithReuseIdentifier: "postCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardCollectionViewCell: UICollectionViewDelegate {
}

extension BoardCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell",
                                                 for: indexPath)
                as? BoardPostCollectionViewCell else {
                    return .init()
        }
        
        
        return cell
    }
}

extension BoardCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}
