//
//  LeftAlignedFlowLayout.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
   

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
               var leftMargin = sectionInset.left
               var maxY: CGFloat = -1.0
               attributes?.forEach { layoutAttribute in
                if layoutAttribute.representedElementCategory != .cell { return }
                   if layoutAttribute.frame.origin.y >= maxY {
                       leftMargin = sectionInset.left
                   }

                   layoutAttribute.frame.origin.x = leftMargin

                   leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                   maxY = max(layoutAttribute.frame.maxY , maxY)
               }

               return attributes
    }
}
