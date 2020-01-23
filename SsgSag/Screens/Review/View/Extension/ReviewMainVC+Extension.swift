//
//  ReviewMainVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

extension ReviewMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewPageCell", for: indexPath) as! ReviewPageCollectionViewCell
        
        cell.tabLabel.text = self.tabTitle[indexPath.item].title
        cell.onFocus = self.tabTitle[indexPath.item].onFocus
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 40
        let count = CGFloat(self.tabTitle.count)
        let width: CGFloat = self.view.frame.width / count
        
        return CGSize(width: width, height: height)
    }
}

extension ReviewMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! ReviewPageCollectionViewCell
        cell.onFocus = true
        self.focusIndex.onNext(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ReviewPageCollectionViewCell
        cell.onFocus = false
    }
    
}
