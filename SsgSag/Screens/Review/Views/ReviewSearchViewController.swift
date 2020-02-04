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

    @IBOutlet weak var searchTexfield: UITextField!
    @IBOutlet weak var clubRegisterButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: ReviewSearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReviewSearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewSearchCell")
        
        guard let viewModel = viewModel else {return}
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ReviewSearchViewModel) {
       
        viewModel.cellModel.bind(to: tableView.rx.items(cellIdentifier: "ReviewSearchCell")) { (indexPath, cellViewModel, cell)  in
            guard let cell = cell as? ReviewSearchTableViewCell else {return}
            cell.bind(viewModel: viewModel, row: indexPath)
        }
        .disposed(by: disposeBag)
        
        searchButton.rx
            .tap
            .do(onNext: { [weak self] _ in
                guard let keyword = self?.searchTexfield.text else { return }
                viewModel.fetchCellData(keyword: keyword)
                self?.view.endEditing(true)
            })
            .subscribe()
            .disposed(by: disposeBag)
            
          
        viewModel.isEmpty
            .asDriver()
            .drive(onNext: { [weak self] bool in
                if bool {
                    guard let title = self?.searchTexfield.text else {return}
                    guard title != "" else {return}
                    self?.searchLabel.text = "\'\(title)\'에 대한 검색 결과가 없습니다."
                    self?.clubRegisterButton.setTitle("\'\(title)\' 동아리 등록하러가기", for: .normal)
                } else {
                    self?.searchLabel.text = "\'\(self?.searchTexfield.text)\'에 대한 검색 결과입니다."
                }
                self?.searchLabel.isHidden = !bool
                self?.clubRegisterButton.isHidden = !bool
            })
            .disposed(by: disposeBag)
        
    }
    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
