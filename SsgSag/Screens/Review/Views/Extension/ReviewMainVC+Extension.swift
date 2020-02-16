//
//  ReviewMainVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

extension ReviewMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 40
        let count = CGFloat(self.tabTitle.count)
        let width: CGFloat = self.view.frame.width / count
        
        return CGSize(width: width, height: height)
    }
}

//페이징시 이벤트
extension ReviewMainViewController: ReviewPageDelegate {
    func setPageTabStatus(curIndex: Int) {
        self.focusIndex.onNext(curIndex)
    }
    
}
