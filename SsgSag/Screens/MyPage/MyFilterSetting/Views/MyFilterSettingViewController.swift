//
//  MyFilterSettingViewController.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

private enum Section: Int {
    
    case myInfo
    case interestedField
    case interestedJob
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
    
}

class MyFilterSettingViewController: UIViewController, StoryboardView {
    //TODO: 전체적으로 폰트 변경 및 사이즈 변경사항 적용해야함
    var disposeBag = DisposeBag()
    var callback: (() -> ())?
    
    typealias Reactor = MyFilterSettingViewReactor

    @IBOutlet weak var filteringCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUiComponnents()
    }
    
    func setUpUiComponnents() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        let leftBarbutton = UIBarButtonItem(customView: backButton)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        ).disposed(by: disposeBag)
        
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
        
        saveButton.rx.tap
            .throttle(0.5, latest: true,
                  scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] event -> Observable<AlertType> in
                guard let self = self else { return Observable.just(AlertType.cancel) }
                let setting = reactor.currentState.myFilterSetting
                if setting.interestedJob.isEmpty
                    || setting.interestedField.isEmpty {
                    return self.makeAlertObservable(title: "각 항목을 1개 이상 선택해주세요")
                } else {
                     return self.makeAlertObservable(title: "정보 저장", message: "입력하신 정보를 저장하시겠습니까")
                }
            }
            .flatMapLatest { [weak reactor] type -> Observable<BasicResponse> in
                guard let reactor = reactor else { return .empty() }
                switch type {
                case .ok:
                    return reactor.myFilterService.save(filterSetting: reactor.currentState.myFilterSetting)
                case .warning:
                    return .empty()
                case .cancel:
                    return .empty()
                }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.callback?()
                self?.navigationController?.popViewController(animated: true)
                AppEvents.logEvent(AppEvents.Name(rawValue: "EVENT_NAME_CUSTOMIZED_FILTER") )
            }, onError: { [weak self] _ in
                self?.simplerAlert(title: "저장에 실패했습니다.")
            })
            .disposed(by: disposeBag)

        let itemSelectedObservable =  filteringCollectionView.rx.itemSelected.share()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<FilterSectionModel>(configureCell: { dataSource, collectionView, indexPath, targetReactor in
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
                switch Section(at: indexPath) {
                case .myInfo:
                    guard let footer = collectionView
                        .dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: "MyFilterFooterCollectionReusableView",
                                                          for: indexPath)
                        as? MyFilterFooterCollectionReusableView else {
                                                            return emptyView
                    }
                    return footer
                default:
                    return emptyView
                }
            }
        })
    
        Observable.just(reactor.currentState.observableSections)
            .bind(to: filteringCollectionView.rx.items(dataSource: dataSource)
            )
            .disposed(by: disposeBag)
        
        itemSelectedObservable
            .subscribe(onNext: { indexPath in
        
        let buttonCellReactor = reactor.buttonCellViewReactors[indexPath.section][indexPath.item]
        let selectedJobKinds = reactor.currentState.myFilterSetting.interestedJob.count
        Observable.just(MyFilterButtonCollectionViewCellReactor.Action.userPressed(indexPath, selectedJobKinds))
            .bind(to: buttonCellReactor.action)
            .disposed(by: self.disposeBag)
            }, onError: nil)
            .disposed(by: disposeBag)

        itemSelectedObservable
            .map { indexPath in Reactor.Action.update(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension MyFilterSettingViewController: UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch Section(section: section) {
        case .myInfo:
            return UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
        case .interestedField:
            return UIEdgeInsets(top: 16, left: 0, bottom: 40, right: 0)
        case .interestedJob:
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(at: indexPath)
        switch section {
        case .myInfo:
            let titleString = self.reactor?.currentState.sections[indexPath.section][indexPath.item] ?? ""
            return MyFilterSizeLayout.calculateItemSize(by: .myInfo,
                                                        targetString: titleString)
        case .interestedField:
            let titleString = self.reactor?.currentState.sections[indexPath.section][indexPath.item] ?? ""
            return MyFilterSizeLayout.calculateItemSize(by: .interestedField,
                                                        targetString: titleString)
        case .interestedJob:
            let titleString = self.reactor?.currentState.sections[indexPath.section][indexPath.item] ?? ""
            return MyFilterSizeLayout.calculateItemSize(by: .interestedJob,
                                                        targetString: titleString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch Section(section: section) {
        case .myInfo:
            return MyFilterSizeLayout.headerSize(by: .myInfo)
        case .interestedField:
            return MyFilterSizeLayout.headerSize(by: .interestedField)
        case .interestedJob:
            return MyFilterSizeLayout.headerSize(by: .interestedJob)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        switch Section(section: section) {
        case .myInfo:
            return MyFilterSizeLayout.footerSize
        default:
            return .zero
        }
    }
}
