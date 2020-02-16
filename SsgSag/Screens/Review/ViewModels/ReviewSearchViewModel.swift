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
        searchService.requestClubWithName(clubType: clubType, location: "서울", keyword: keyword, curPage: 0) { data in
            guard let data = data else {
                self.cellModel.accept([])
                return
            }
            self.cellModel.accept(data)
        }
    }
}
