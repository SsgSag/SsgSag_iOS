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
    
    var targetView: UICollectionView?
    
    func connect(with dataSource: UICollectionViewDataSource) {
        targetView?.dataSource = dataSource
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
        
        targetView = cell.monthCollectionView
//        cell.configure(months[indexPath.item])
        
        return cell
    }
}
