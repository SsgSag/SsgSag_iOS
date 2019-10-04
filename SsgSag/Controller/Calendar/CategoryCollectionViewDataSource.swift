//
//  CategoryCollectionViewDataSource.swift
//  SsgSag
//
//  Created by 이혜주 on 04/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
