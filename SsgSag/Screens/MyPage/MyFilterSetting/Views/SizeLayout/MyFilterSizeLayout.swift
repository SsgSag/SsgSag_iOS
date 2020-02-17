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
        case myInfo
        case interestedField
        case interestedJob
        case interestedJobField
    }
    
    static let screenWidth = UIScreen.main.bounds.width
    static let insets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32.5)
    static let itemHeight: CGFloat = 30
    static let headerSize = CGSize(width: screenWidth, height: 45)
    static let footerSize = CGSize(width: screenWidth, height: 53)
    
    static func inheritsSpacing(for section: MyFilterSection) -> CGFloat {
        switch section {
        case .myInfo:
            return 11
        case .interestedField:
            return 8
        case .interestedJob, .interestedJobField:
            return 0
        }
    }
    
    static func minimumSpacing(for section: MyFilterSection) -> CGFloat {
        switch section {
        case .myInfo:
            return 8
        case .interestedField:
            return 9
        case .interestedJob, .interestedJobField:
            return 0
        }
    }
    
    static func headerSize(by section: MyFilterSection) -> CGSize {
        switch section {
        case .myInfo:
            return .init(width: screenWidth, height: 23)
        case .interestedField:
            return .init(width: screenWidth, height: 45)
        case .interestedJob:
            return .init(width: screenWidth, height: 63)
        case .interestedJobField:
            return .init(width: screenWidth, height: 0)
        }
    }
    
    static func calculateItemSize(by section: MyFilterSection,
                                  targetString: String,
                                  currentViewSize: CGSize = .zero) -> CGSize {
        switch section {
        case .myInfo:
            let textMargin: CGFloat = 8
            let calculatedRect = targetString.estimatedFrame(font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            return CGSize(width: calculatedRect.width + textMargin * 2,
                        height: itemHeight)
        default:
            let textMargin: CGFloat = 8
            let calculatedRect = "#\(targetString)".estimatedFrame(font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            return CGSize(width: calculatedRect.width + textMargin * 2,
                        height: itemHeight)
        }
       
    }
}
