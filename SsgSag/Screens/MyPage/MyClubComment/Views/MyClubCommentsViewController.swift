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
    
    private let emptyViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "내가 쓴 후기가 없네요 :("
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    var disposeBag = DisposeBag()
    var viewModel: MyClubViewModel?
    @IBOutlet weak var myClubTableView: UITableView!
    
    @IBOutlet weak var navigationBackButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = MyClubViewModel()
        self.viewModel = viewModel
        bind(viewModel: viewModel)
        myClubTableView.delegate = self
        myClubTableView.dataSource = self
    }
    
    func bind(viewModel: MyClubViewModel) {
        viewModel.buildCellViewModels()
        
        viewModel
            .commentCellViewModels
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.myClubTableView.reloadData()
            })
            .disposed(by: disposeBag)
        navigationBackButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
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
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        if viewModel?.commentCellViewModels.value.isEmpty ?? true {
            return 100
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension MyClubCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.commentCellViewModels.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyClubTableViewCell") as? MyClubTableViewCell, let cellViewModel = viewModel?.commentCellViewModels.value[safe: indexPath.row] else { return .init() }
        cell.bind(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        if viewModel?.commentCellViewModels.value.isEmpty ?? true {
            emptyViewLabel.frame = .init(x: 0,
                                         y: 0,
                                         width: tableView.frame.width,
                                         height: 100)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            view.addSubview(emptyViewLabel)
            return view
        } else {
            return nil
        }
    }
}
