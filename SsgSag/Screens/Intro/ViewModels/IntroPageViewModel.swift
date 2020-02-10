//
//  IntroPageCellViewModel.swift
//  SsgSag
//
//  Created by bumslap on 10/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class IntroPageViewModel {
    let pages: [IntroPage]
    let cellViewModels = BehaviorRelay<[IntroPageCellViewModel]>(value: [])
    init() {
        pages = [ IntroPage(backgroundImageString: "imgIntro1",
                            titleImageString: "introTitle1",
                            introLabelString: "학교/학과, 관심분야만 선택하면\n슥삭이 알아서 찾아드릴게요.",
                            pageNumber: 0),
                  IntroPage(backgroundImageString: "imgIntro2",
                            titleImageString: "introTitle2",
                            introLabelString: "슥삭에서는 스와이프 방식으로\n손쉽게 캘린더에 저장해드릴게요.",
                            pageNumber: 1),
                  IntroPage(backgroundImageString: "imgIntro3",
                            titleImageString: "introTitle3",
                            introLabelString: "먼저 활동했던 친구/선배들의 후기를\n한 곳에 모아서 보여드릴게요.",
                            pageNumber: 2) ]
    }
    
    func buildViewModel() {
        let cellViewModels = pages
            .enumerated()
            .map { IntroPageCellViewModel(backgroundImageString: $0.element.backgroundImageString,
                                          introTitleImageString: $0.element.titleImageString,
                                          introString: $0.element.introLabelString,
                                          isStartAppStackViewHidden: $0.offset != (pages.count - 1),
                                          pageNumber: $0.offset)
                    
            }
        cellViewModels
            .enumerated()
            .forEach {
                $0.element.buildCellViewModel(numberOfPages: pages.count, currentPageNumber: $0.offset)
            }
        self.cellViewModels.accept(cellViewModels)
    }
}
