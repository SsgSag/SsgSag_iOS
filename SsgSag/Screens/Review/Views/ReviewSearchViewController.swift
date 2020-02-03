//
//  ReviewSearchViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReviewSearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewSearchCell")
        
        let viewModel = ReviewSearchViewModel()
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ReviewSearchViewModel) {
        Observable.of(viewModel.cellModel)
            .bind(to: tableView.rx.items(cellIdentifier: "ReviewSearchCell")) { (indexPath, cellViewModel, cell)  in
                guard let cell = cell as? ReviewSearchTableViewCell else {return}
                cell.bind(viewModel: viewModel)
                
        }
        .disposed(by: disposeBag)
        
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
