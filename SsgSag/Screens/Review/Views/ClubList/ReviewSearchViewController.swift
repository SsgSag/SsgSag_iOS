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

class ReviewSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTexfield: UITextField!
    @IBOutlet weak var clubRegisterButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: ReviewSearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "ReviewSearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewSearchCell")
        self.searchTexfield.delegate = self
        
        guard let viewModel = viewModel else {return}
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ReviewSearchViewModel) {
       
        viewModel.cellModel.bind(to: tableView.rx.items(cellIdentifier: "ReviewSearchCell")) { (indexPath, cellViewModel, cell)  in
            guard let cell = cell as? ReviewSearchTableViewCell else {return}
            cell.bind(viewModel: viewModel, row: indexPath)
            cell.delegate = self
        }
        .disposed(by: disposeBag)
        
        viewModel
            .isEmpty
            .asDriver()
            .drive(onNext: { [weak self] bool in
                guard let title = self?.searchTexfield.text else {return}
                if bool {
                    guard title != "" else {return}
                    self?.searchLabel.text = "\'\(title)\'에 대한 검색 결과가 없습니다."
                    self?.clubRegisterButton.setTitle("\'\(title)\' 동아리 등록하러가기", for: .normal)
                } else {
                    self?.searchLabel.text = "\'\(title)\'에 대한 검색 결과입니다."
                }
                self?.searchLabel.isHidden = !bool
                self?.clubRegisterButton.isHidden = !bool
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cellEvent in
                let indexPath = cellEvent.indexPath
                if indexPath.row == viewModel.cellCount()-1 {
                    guard let title = self?.searchTexfield.text else {return}
                    viewModel.nextPage()
                    viewModel.fetchCellData(keyword: title)
                }
            })
            .disposed(by: disposeBag)
        
        searchTexfield
            .rx
            .text
            .orEmpty
            .changed
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.curPage = 0
            })
            .disposed(by: disposeBag)
        
        searchButton
            .rx
            .tap
            .do(onNext: { [weak self] _ in
                guard let keyword = self?.searchTexfield.text else { return }
                viewModel.fetchRefreshCell(keyword: keyword)
                self?.view.endEditing(true)
            })
            .subscribe()
            .disposed(by: disposeBag)
            
        
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = self.searchTexfield.text else { return false }
        guard let viewModel = viewModel else { return false }
        viewModel.fetchRefreshCell(keyword: keyword)
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func registerClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubManagerVC") else {return}
        self.present(nextVC, animated: true)
    }
}

extension ReviewSearchViewController: ClubListSelectDelgate {
    func clubDetailClick(clubIdx: Int) {
          let nextVC = UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubDetailVC") as! ClubDetailViewController
              nextVC.clubIdx = clubIdx
        nextVC.tabViewModel = ClubDetailViewModel()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
