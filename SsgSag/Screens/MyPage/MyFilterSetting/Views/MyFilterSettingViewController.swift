//
//  MyFilterSettingViewController.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

private enum Section: Int {
    case jobKind
    case interestedField
    case userGrade
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
    
}

class MyFilterSettingViewController: UIViewController, StoryboardView {
    
    var disposeBag = DisposeBag()
    
    typealias Reactor = MyFilterSettingViewReactor

    @IBOutlet weak var filteringCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUiComponnents()
    }
    
    func setUpUiComponnents() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ic_ArrowBack"), for: .normal)
        let leftBarbutton = UIBarButtonItem(customView: backButton)
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        title = "맞춤 추천 설정"
        navigationItem.leftBarButtonItem = leftBarbutton
        setNavigationBar(color: .white)
        
        //collectionView
         filteringCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
         filteringCollectionView
            .register(UICollectionReusableView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: "UICollectionReusableView")
        
         let sliderCellNib = UINib(nibName: "MyFilterSliderCollectionViewCell",
         bundle: nil)

         filteringCollectionView
            .register(sliderCellNib,
                      forCellWithReuseIdentifier: "MyFilterSliderCollectionViewCell")
        
         
         let myFilterCollectionReusableViewNib = UINib(nibName: "MyFilterCollectionReusableView",
                                                       bundle: nil)
         filteringCollectionView
            .register(myFilterCollectionReusableViewNib,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: "MyFilterCollectionReusableView")
        
         let myFilterCollectionFooterReusableViewNib = UINib(nibName: "MyFilterFooterCollectionReusableView",
                                                             bundle: nil)
         filteringCollectionView
            .register(myFilterCollectionFooterReusableViewNib,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: "MyFilterFooterCollectionReusableView")
    }
    
    func bind(reactor: MyFilterSettingViewReactor) {
        let itemSelectedObservable =  filteringCollectionView.rx.itemSelected.share()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<FilterSectionModel>(configureCell: { dataSource, collectionView, indexPath, targetReactor in
            let section = Section(at: indexPath)
            switch section {
            case .jobKind, .interestedField:
                guard let reactor = targetReactor as? MyFilterButtonCollectionViewCellReactor else { return .init() }
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: "MyFilterButtonCollectionViewCell",
                                         for: indexPath)
                    as? MyFilterButtonCollectionViewCell else { return .init() }
                cell.reactor = reactor
                Observable.just(()).map {
                    _ in MyFilterButtonCollectionViewCellReactor.Action.set
                }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
                    
                return cell
            case .userGrade:
                guard let reactor = targetReactor as? MyFilterSliderCollectionViewCellReactor else { return .init() }
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: "MyFilterSliderCollectionViewCell",
                                         for: indexPath)
                    as? MyFilterSliderCollectionViewCell else { return .init() }
                cell.reactor = reactor
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "UICollectionReusableView",
            for: indexPath)
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: "MyFilterCollectionReusableView",
                                                      for: indexPath)
                    as? MyFilterCollectionReusableView else {
                                                        return emptyView
                }
                header.configure(header: reactor.currentState.headers[indexPath.section])
                return header
               
            default:
                guard let footer = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: "MyFilterFooterCollectionReusableView",
                                                      for: indexPath)
                    as? MyFilterFooterCollectionReusableView else {
                                                        return emptyView
                }

                footer.confirmButton.rx.tap
                    .throttle(0.5, scheduler: MainScheduler.instance)
                    .flatMapLatest { [weak self] event -> Observable<AlertType> in
                        guard let self = self else { return Observable.just(AlertType.cancel) }
                        return self.makeAlertObservable(title: "정보 저장", message: "입력하신 정보를 저장하시겠습니까")
                    }
                    .flatMapLatest { type -> Observable<BasicResponse> in
                        switch type {
                        case .ok:
                            return reactor.service.save(filterSetting: reactor.currentState.myFilterSetting)
                        case .cancel:
                            return .empty()
                        }
                    }
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }, onError: { _ in
                        self.simplerAlert(title: "저장에 실패했습니다.")
                    })
                    .disposed(by: footer.disposeBag)
                return footer
            }
        })
    
        reactor.sections
            .bind(to: filteringCollectionView
                .rx
                .items(dataSource: dataSource)
            )
            .disposed(by: disposeBag)
        
        itemSelectedObservable
            .subscribe(onNext: { indexPath in
        
        let buttonCellReactor = reactor.currentState.buttonCellViewReactors[indexPath.section][indexPath.item]
                let selectedJobKinds = reactor.currentState.myFilterSetting.jobKind.count 
        Observable.just(MyFilterButtonCollectionViewCellReactor.Action.userPressed(indexPath, selectedJobKinds))
            .bind(to: buttonCellReactor.action)
            .disposed(by: self.disposeBag)
            }, onError: nil)
            .disposed(by: disposeBag)
        
        
        let sliderCellReactor = reactor.currentState.sliderCellViewReactor
        sliderCellReactor.state.map { $0.value }
            .map { value in Reactor.Action.update(IndexPath(item: 0, section: 2), value)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        itemSelectedObservable
            .map { indexPath in Reactor.Action.update(indexPath, nil) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}

extension MyFilterSettingViewController: UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let section = Section(section: section)
        switch section {
        case .jobKind, .interestedField:
            return UIEdgeInsets(top: 12, left: 0, bottom: 30, right: 0)
        case .userGrade:
            return UIEdgeInsets(top: 12, left: 0, bottom: 73, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(at: indexPath)
        switch section {
        case .jobKind:
            return MyFilterSizeLayout.calculateItemSize(by: .jobKind)
        case .interestedField:
            let titleString = self.reactor?.currentState.sections[indexPath.section][indexPath.item] ?? ""
            return MyFilterSizeLayout.calculateItemSize(by: .interestedField,
                                                        targetString: titleString)
        case .userGrade:
            return MyFilterSizeLayout.calculateItemSize(by: .userGrade,
                                                        currentViewSize: collectionView.bounds.size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return MyFilterSizeLayout.headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = Section(section: section)
        switch section {
        case .jobKind, .interestedField:
            return .zero
        case .userGrade:
            return MyFilterSizeLayout.footerSize
        }
    }
}
