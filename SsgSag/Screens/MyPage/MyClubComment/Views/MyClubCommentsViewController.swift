//
//  MyClubCommentsViewController.swift
//  SsgSag
//
//  Created by bumslap on 28/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyClubCommentsViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: MyClubViewModel?
    @IBOutlet weak var myClubTableView: UITableView!
    
    @IBOutlet weak var navigationBackButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = MyClubViewModel()
        self.viewModel = viewModel
        bind(viewModel: viewModel)
        myClubTableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bind(viewModel: MyClubViewModel) {
        viewModel.buildCellViewModels()
        
        navigationBackButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.commentCellViewModels.asObservable()
            .bind(to: myClubTableView.rx.items(cellIdentifier: "MyClubTableViewCell")) { (indexPath, cellViewModel, cell)  in
                guard let cell = cell as? MyClubTableViewCell else { return }
                cell.bind(viewModel: cellViewModel)
        }
        .disposed(by: disposeBag)
        
        
        myClubTableView
            .rx
            .contentOffset
            .withLatestFrom(viewModel.isLoading) { (offset: $0, isLoading: $1) }
            .filter { !$0.isLoading }
            .map { $0.offset.y }
            .filter { (($0 + self.myClubTableView.frame.height) >= (self.myClubTableView.contentSize.height - 100)) }
            .subscribe(onNext: { [weak viewModel] feeds in
                guard let viewModel = viewModel else { return }
                viewModel.buildCellViewModels()
            })
            .disposed(by: disposeBag)
    }
    
}

extension MyClubCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

