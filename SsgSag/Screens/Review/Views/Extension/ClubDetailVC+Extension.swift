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
        
        let widthEstimate = self.view.frame.width/2
        let size = CGSize(width: widthEstimate, height: 18)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Apple SD 산돌고딕 Neo", size: 10.0) as Any]
        let estimateSize = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        //폰트가로크기오차 6 마진 8
        //폰트세로크기오차 2 마진 8
        return CGSize(width: estimateSize.width+6+8, height: estimateSize.height+2+8)
    }
}

