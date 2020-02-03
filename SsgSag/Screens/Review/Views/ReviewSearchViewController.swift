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

    @IBOutlet weak var clubRegisterButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
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
       
        viewModel.cellModel.bind(to: tableView.rx.items(cellIdentifier: "ReviewSearchCell")) { (indexPath, cellViewModel, cell)  in
            guard let cell = cell as? ReviewSearchTableViewCell else {return}
            cell.bind(viewModel: viewModel)
        }
        .disposed(by: disposeBag)
        
        searchButton.rx
            .tap
            .do(onNext: {
                viewModel.cellModel.accept([])
            })
            .subscribe()
            .disposed(by: disposeBag)
            
          
        
        viewModel.isEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] bool in
                self?.clubRegisterButton.isHidden = !bool
                self?.searchLabel.isHidden = !bool
            })
            .disposed(by: disposeBag)
        
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
