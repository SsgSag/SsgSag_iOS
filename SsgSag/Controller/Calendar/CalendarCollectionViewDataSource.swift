//
//  CalendarCollectionViewDataSource.swift
//  SsgSag
//
//  Created by 이혜주 on 04/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CalendarCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var months: [HJMonth]?
    
//    var targetView: UICollectionView?
    var dataSource: UICollectionViewDataSource?
    
    func connect(with dataSource: UICollectionViewDataSource) {
//        targetView?.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return months?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell",
                                                            for: indexPath)
            as? MonthCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        guard let month = months?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
//        targetView = cell.monthCollectionView
        cell.monthCollectionView.dataSource = dataSource
        cell.configure(month: month)
        
        guard let monthDataSource = cell.monthCollectionView.dataSource as? MonthCollectionViewDataSource else {
            return cell
        }
        
        monthDataSource.days = month.days
        monthDataSource.numberOfCell = month.numberOfDay + month.startDay - 1
        
        return cell
    }
}
