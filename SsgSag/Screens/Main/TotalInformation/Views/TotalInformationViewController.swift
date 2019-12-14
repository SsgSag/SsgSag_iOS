//
//  TotalInfomationViewController.swift
//  SsgSag
//
//  Created by bumslap on 07/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

private enum Section: Int {
    case contest
    case activity
    case internship
    case etc
    case lecture
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
    
}

class TotalInformationViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var totalTableView: UITableView!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: TotalInformationReactor) {
       
        Observable.from(TotalInfoCategoryType.allCases.map { $0.rawValue })
            .map { type in Reactor.Action.loadItems }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentItems }
            .bind(to: totalTableView.rx.items(cellIdentifier: "TotalInformationTableViewCell"))
            { indexPath, item, cell in

                guard let type = TotalInfoCategoryType.allCases[safe: indexPath] else { return }
                guard let cell = cell as? TotalInformationTableViewCell else { return }

                cell.itemCollectionView.delegate = self
                cell.reactor = TotalInformationTableViewCellReactor(type: type, items: item.value)
                Observable.just(())
                    .map { TotalInformationTableViewCellReactor.Action.set("") }
                    .bind(to: cell.reactor!.action)
                    .disposed(by: cell.disposeBag)
                cell.moreButton.rx.tap.subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    let allPostersViewController = AllPostersListViewController()
                    self.navigationController?.pushViewController(allPostersViewController,
                                                                  animated: true)
                    //item.key
                }).disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        
    }
    
}

extension TotalInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 334
    }
}
//
//extension TotalInformationViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return TotalInfoCategoryType.allCases.count
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalInformationTableViewCell",
//                                                       for: indexPath) as? TotalInformationTableViewCell else { return .init() }
//        guard let type = TotalInfoCategoryType.allCases[safe: indexPath.item] else { return .init() }
//        guard let items = reactor?.currentState.currentItems[type] else { return .init() }
//        cell.reactor = TotalInformationTableViewCellReactor(type: type, items: items)
//        Observable.just(()).map { TotalInformationTableViewCellReactor.Action.set("") }.bind(to: cell.reactor!.action).disposed(by: cell.disposeBag)
//        //cell.itemCollectionView.dataSource = self
//        //cell.itemCollectionView.delegate = self
//        return cell
//    }
//}




extension TotalInformationViewController: UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
}
//extension TotalInformationViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//    
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    
//    
//}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
