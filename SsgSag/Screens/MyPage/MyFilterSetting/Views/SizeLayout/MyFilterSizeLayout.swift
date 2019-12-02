//
//  MyFilterSizeLayout.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class MyFilterSizeLayout {
    
    enum MyFilterSection: Int {
        case jobKind
        case interestedField
        case userGrade
    }
    
    static let screenWidth = UIScreen.main.bounds.width
    static let insets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32.5)
    static let itemHeight: CGFloat = 30
    static let headerSize = CGSize(width: screenWidth, height: 39)
    static let footerSize = CGSize(width: screenWidth, height: 48)
    
    static func inheritsSpacing(for section: MyFilterSection) -> CGFloat {
        switch section {
        case .jobKind:
            return 11
        case .interestedField:
            return 8
        case .userGrade:
            return 0
        }
    }
    
    static func minimumSpacing(for section: MyFilterSection) -> CGFloat {
        switch section {
        case .jobKind:
            return 8
        case .interestedField:
            return 9
        case .userGrade:
            return 0
        }
    }
    
    static func calculateItemSize(by section: MyFilterSection,
                                  targetString: String = "",
                                  currentViewSize: CGSize = .zero
    ) -> CGSize {
        let viewWidth = screenWidth - (insets.left + insets.right)
        switch section {
        case .jobKind:
            let itemWidth = (viewWidth - inheritsSpacing(for: .jobKind)) / 2
            return CGSize(width: itemWidth, height: itemHeight)
        case .interestedField:
            let textMargin: CGFloat = 15
            let calculatedRect = targetString.estimatedFrame(font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            return CGSize(width: calculatedRect.width + textMargin * 2,
                          height: itemHeight)
        case .userGrade:
            return CGSize(width: viewWidth,
                          height: 45)
          
        }
    }
}
