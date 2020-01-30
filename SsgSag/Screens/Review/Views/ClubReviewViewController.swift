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
    var reviewDataSet: [ReviewInfo] = []
    
    @IBOutlet weak var normalReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disposeBag = DisposeBag()
        bind()
        self.normalReviewTableView.dataSource = self
        self.normalReviewTableView.estimatedRowHeight = 400
        self.normalReviewTableView.rowHeight = UITableView.automaticDimension
    }
    
    func bind() {
        self.tabViewModel.reviewDataSet
        .filter { $0 != nil }
        .map { $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            guard data != nil else {return}
            self?.reviewDataSet = data!
            self?.normalReviewTableView.reloadData()
            
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("memory - review 종료")
    }

}
