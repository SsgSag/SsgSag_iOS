//
//  MonthCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    var month: Int = 0
    
    private lazy var monthCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: frame.width / 7,
                                 height: frame.height / 4)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(monthCollectionView)
        
        monthCollectionView.topAnchor.constraint(
        equalTo: topAnchor).isActive = true
        monthCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
        monthCollectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        monthCollectionView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let dayNib = UINib(nibName: "DayCollectionViewCell", bundle: nil)
        
        monthCollectionView.register(dayNib, forCellWithReuseIdentifier: "dayCell")
    }
}

extension MonthCollectionViewCell: UICollectionViewDelegate {
    
}

extension MonthCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell",
                                                            for: indexPath) as? DayCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        return cell
    }
}
