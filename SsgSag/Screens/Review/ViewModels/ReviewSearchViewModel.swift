//
//  ReviewSearchViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/03.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewSearchViewModel {
    let searchService: ClubServiceProtocol
    let cellModel: BehaviorRelay<[ClubListData]> = BehaviorRelay(value: [])
    let isEmpty = BehaviorRelay(value: true)
    let clubType: ClubType
    var curPage = 0
    var disposeBag: DisposeBag
    
    init(clubType: ClubType, service: ClubServiceProtocol = ClubService()) {
        disposeBag = DisposeBag()
        searchService = service
        self.clubType = clubType
        bind()
    }
    
    func bind() {
        cellModel
            .subscribe(onNext: { [weak self] datas in
            if datas.isEmpty {
                self?.isEmpty.accept(true)
            }else {
                self?.isEmpty.accept(false)
            }
        })
            .disposed(by: disposeBag)
    }
    
    func fetchCellData(keyword: String) {
        searchService.requestClubListWithName( keyword: keyword, curPage: curPage) { data in
            guard let data = data else { return }
            if data.count == 0 {
                self.curPage -= 1
                return
            }
            var tempCellModel = self.cellModel.value
            data.forEach { tempCellModel.append($0) }
            self.cellModel.accept(tempCellModel)
        }
    }
    
    func fetchRefreshCell(keyword: String) {
        self.cellRemoveAll()
        searchService.requestClubListWithName( keyword: keyword, curPage: curPage) { data in
            guard let data = data else { return }
            if data.count == 0 {
                self.curPage -= 1
                return
            }
            var tempCellModel = self.cellModel.value
            data.forEach { tempCellModel.append($0) }
            self.cellModel.accept(tempCellModel)
        }
    }
    
    func nextPage() {
        curPage += 1
    }
    
    func cellCount() -> Int {
        return cellModel.value.count
    }
    
    func cellRemoveAll() {
        cellModel.accept([])
    }
}
