//
//  MyClubViewModel.swift
//  SsgSag
//
//  Created by bumslap on 07/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyClubViewModel {
    let service: MyClubServiceProtocol = MyClubService()
    let commentCellViewModels = BehaviorRelay<[MyClubCellViewModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    var currentPageNumber = 0
    var disposeBag = DisposeBag()
    
    deinit {
        debugPrint("ClubViewModel deinit")
    }
    func buildCellViewModels() {
        
        isLoading.accept(true)
        service
            .requestMyClubComments(page: currentPageNumber)
            .filter { $0.count > 0 }
            .flatMapLatest { [weak self] (comments) -> Observable<[MyClubComment]> in
                self?.currentPageNumber += 1
                return .just(comments)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] comments in
                let cellViewModels = comments
                    .map {
                        MyClubCellViewModel(clubType: $0.clubType ?? 0,
                                            titleText: $0.clubName ?? "",
                                            dateText: $0.regDate ?? "",
                                            approval: $0.adminAccept ?? 0)
                }
                self?.commentCellViewModels.accept(cellViewModels)
                self?.isLoading.accept(false)
                }, onError: { [weak self] error in
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
