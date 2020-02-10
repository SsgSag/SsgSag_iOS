//
//  IntroPageViewModel.swift
//  SsgSag
//
//  Created by bumslap on 10/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class IntroPageCellViewModel {
    let backgroundImageString = BehaviorRelay<String>(value: "")
    let introTitleImageString = BehaviorRelay<String>(value: "")
    let introString = BehaviorRelay<String>(value: "")
    let isStartAppStackViewHidden = BehaviorRelay<Bool>(value: true)
    let pageDotAlphaArray = BehaviorRelay<[CGFloat]>(value: [1.0, 1.0, 1.0])
    let pageNumber: Int
    
    var callback: (() -> Void)?
    
    init(backgroundImageString: String,
         introTitleImageString: String,
         introString: String,
         isStartAppStackViewHidden: Bool,
         pageNumber: Int) {
        self.pageNumber = pageNumber
        self.backgroundImageString.accept(backgroundImageString)
        self.introTitleImageString.accept(introTitleImageString)
        self.introString.accept(introString)
        self.isStartAppStackViewHidden.accept(isStartAppStackViewHidden)
    }
    
    func buildCellViewModel(numberOfPages: Int,
                            currentPageNumber: Int) {
       let alphaValues = calculatePpageDotVisibility(by: currentPageNumber, in: numberOfPages)
        
        pageDotAlphaArray.accept(alphaValues)
    }
    
    func calculatePpageDotVisibility(by pageNumber: Int, in numberOfPages: Int) -> [CGFloat] {
       let alphaArray = Array(repeating: 1, count: numberOfPages)
        .enumerated()
        .map { tuple -> CGFloat in
            if tuple.offset == pageNumber {
                return 1.0
            } else {
                return 0.3
            }
        }
        return alphaArray
    }
    
    func userPressedStartButton() {
        callback?()
    }
}
