//
//  MonthCollectionViewDataSource.swift
//  SsgSag
//
//  Created by 이혜주 on 04/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class MonthCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var days: [HJDay]?
    var numberOfCell: Int = 0
//    var targetView: UICollectionView?
    var dataSource: UICollectionViewDataSource?
    
    func connect(with dataSource: UICollectionViewDataSource) {
//        targetView?.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let numberOfDay = days?.count else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell",
                                                            for: indexPath) as? DayCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        guard numberOfCell - numberOfDay - 1 < indexPath.item else {
            return cell
        }
        
//        targetView = cell.dayCollectionView
        cell.dayCollectionView.dataSource = dataSource
        cell.configure(days?[indexPath.item - (numberOfCell - numberOfDay)])
                    
        return cell
    }
}
