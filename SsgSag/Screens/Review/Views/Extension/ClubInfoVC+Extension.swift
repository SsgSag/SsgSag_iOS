//
//  ClubInfoVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

extension ClubInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imgSet.count > showPhotoMaximum {
            return showPhotoMaximum
        }
        
        return self.imgSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubPhotoCell", for: indexPath) as! ClubPhotoCollectionViewCell
    
        cell.imgString = self.imgSet[indexPath.item]
        
        let dataNum = self.imgSet.count
        if indexPath.item == showPhotoMaximum-1 && dataNum > showPhotoMaximum {
            
            let gap = dataNum - showPhotoMaximum
            cell.morePhotoView(moreCount: gap)
        } else {
            cell.hideView()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (self.photoCollectionView.frame.width - 3) / 3

        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

}
