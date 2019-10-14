//
//  DayCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayTitleLabel: UILabel!    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
    }
    
    func configure(_ day: HJDay?) {
        guard let day = day else {
            return
        }
        
        dayTitleLabel.text = "\(day.day)"
    }
}

extension DayCollectionViewCell: UICollectionViewDelegate {
    
}

//extension DayCollectionViewCell: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
//    }
//}
