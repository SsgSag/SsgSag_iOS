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
    let cellModel: BehaviorRelay<[String]> = BehaviorRelay(value: ["1","2","22"])
    let isEmpty = BehaviorRelay(value: true)
    var disposeBag: DisposeBag
    
    init() {
        disposeBag = DisposeBag()
        bind()
    }
    
    func bind() {
        cellModel
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] datas in
            if datas.isEmpty {
                self?.isEmpty.accept(true)
            }else {
                self?.isEmpty.accept(false)
            }
        })
            .disposed(by: disposeBag)
    }
}
