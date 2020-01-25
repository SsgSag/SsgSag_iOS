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
        
//        클릭시 해당 인덱스의 페이지로 이동 아직 페이지 미구현이므로 주석처리하였습니다.
//        let cell = collectionView.cellForItem(at: indexPath) as! ReviewPageCollectionViewCell
//        self.tabTitle[indexPath.item].onFocus = true
//        cell.onFocus = true
//        self.focusIndex.onNext(indexPath.item)
        guard indexPath.item != 0 else { return }
        self.simplerAlert(title: "아직 준비중이에요!!")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

//        클릭시 해당 인덱스의 페이지로 이동 아직 페이지 미구현이므로 주석처리하였습니다.
//        let cell = collectionView.cellForItem(at: indexPath) as! ReviewPageCollectionViewCell
//        self.tabTitle[indexPath.item].onFocus = false
//        cell.onFocus = false
    }
    
}
//페이징시 이벤트
extension ReviewMainViewController: ReviewPageDelegate {
    func setPageTabStatus(index: Int) {
        
        self.tabCollectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: false)
        self.tabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .left)
        
    }
}
