//
//  ClubReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ClubReviewViewController: UIViewController {
    let tabViewModel = ClubDetailViewModel.shared
    var disposeBag: DisposeBag!
//    var reviewDataSet: [ReviewInfo]!
    @IBOutlet weak var normalReviewCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disposeBag = DisposeBag()
        bind()
    }
    
    func bind() {
        self.tabViewModel.reviewDataSet
        .filter { $0 != nil }
        .map { $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            self?.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("memory - review 종료")
    }

}
