//
//  ClubDetailVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

extension ClubDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.clubCategorySet.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 카테고리
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubCategoryCell", for: indexPath) as! ClubCategoryCollectionViewCell
        cell.categoryLabel.text = self.clubCategorySet[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = self.clubCategorySet[indexPath.row]
        
        let width = title.estimatedFrame(font: UIFont.fontWithName(type: .regular, size: 10)).width
        
        return CGSize(width: width + 10, height: 18)
    }
}

