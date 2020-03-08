//
//  FeedVC.swift
//  SsgSag
//
//  Created by 이혜주 on 11/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AdBrixRM
import RxSwift
import RxCocoa

enum FeedPageType: CaseIterable {
    //TODO: 케이스가 추가될 예정이다
    case recommendedNews
    case none
    
    init(at indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self = .recommendedNews
        default:
            self = .none
        }
    }
    
    func page(at indexPath: IndexPath) -> FeedPageType {
        switch indexPath.item {
        case 0:
            return .recommendedNews
        default:
            return .none
        }
    }
}

class FeedViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var myPageButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    
        let coachMarkViewController = FirstCoachmarkViewController()
        coachMarkViewController.modalPresentationStyle = .overFullScreen
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        coachMarkViewController.bind(viewModel: CoachMarkViewModel(with: .feed(.init(x: 0, y: tabBarHeight))))
        self.present(coachMarkViewController,
                     animated: false)
        setNavigationBar(color: .white)
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return
        }
        
        if !isTryWithoutLogin {
            exitButton.setImage(UIImage(named: "icBookmarkFilled"), for: .normal)
            exitButton.tintColor = .unselectedButtonDefault
            exitButton.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let viewModel = FeedViewModel()
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: FeedViewModel) {
        
        let isNotLoggedIn = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool
        let pageViewModel = FeedPageViewModel(type: .recommendedNews)
        
        exitButton
            .rx
            .tap
            .flatMapLatest { Observable.just(isNotLoggedIn ?? true) }
            .do(onNext: { [weak self] (isNotLoggedIn) in
                
                if isNotLoggedIn {
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard",
                                                                  bundle: nil)
                    let splashViewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC")
                    let rootNavigationController = UINavigationController(rootViewController: splashViewController)
                    UIApplication.shared.delegate?.window??.rootViewController = rootNavigationController
                } else {
                    let scrapViewController = ScrapViewController()
                    scrapViewController.bind(viewModel: pageViewModel)
                    self?.navigationController?.pushViewController(scrapViewController,
                                                                   animated: true)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        myPageButton
            .rx
            .tap
            .flatMapLatest{ [weak self] _ -> Observable<AlertType> in
                guard let self = self else { return .empty() }
                let isNotLoggedIn = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool
                if isNotLoggedIn ?? true {
                    return self.makeAlertObservable(title: "마이페이지", message: "로그인 후 이용해주세요")
                } else {
                    return .just(AlertType.warning)
                }
            }
            .do(onNext: { [weak self] type in
                switch type {
                case .ok:
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard",
                                                                 bundle: nil)
                    let splashViewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC")
                    let rootNavigationController = UINavigationController(rootViewController: splashViewController)
                    UIApplication.shared.delegate?.window??.rootViewController = rootNavigationController
                case .warning:
                    let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)

                    let myPageViewController =
                        myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)

                    let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
                    myPageViewNavigator.modalPresentationStyle = .fullScreen

                    self?.present(myPageViewNavigator,
                                  animated: true)
                case .cancel:
                    return
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        Observable.of(viewModel.pageViewModels.filter { $0.pageType == .recommendedNews })
            .bind(to: newsCollectionView.rx.items(cellIdentifier: "feedCell")) { (indexPath, cellViewModel, cell)  in
                guard let cell = cell as? FeedPageCollectionViewCell else { return }
                cell.bind(viewModel: cellViewModel)
                cell.feedCollectionView
                    .rx
                    .itemSelected
                    .do(onNext: { [weak self, weak viewModel] (index) in
                         let newsViewModel = viewModel?
                            .pageViewModels
                            .filter { $0.pageType == .recommendedNews }
                            .first?
                            .newsCellViewModels.value[index.item]
                        
                        guard let cellViewModel = newsViewModel else { return }
                        let adBrix = AdBrixRM.getInstance
                        adBrix.event(eventName: "touchUp_FeedNews",
                                     value: ["feedUrl": cellViewModel.feed.feedUrl ?? ""])
                               
                        let articleVC = ArticleViewController()
                        articleVC.articleTitle = cellViewModel.feed.feedName ?? ""
                        articleVC.articleUrlString = cellViewModel.feed.feedUrl ?? ""
                        articleVC.feedIdx = cellViewModel.feed.feedIdx ?? 0
                        articleVC.isSave = cellViewModel.saveButtonImageName.value == "ic_bookmarkArticlePassive" ? 0 : 1

                        self?.navigationController?.pushViewController(articleVC,
                                                                 animated: true)
                    })
                    .subscribe()
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        
        if let flowLayout = newsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        newsCollectionView.register(FeedPageCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "feedCell")
        
        newsCollectionView.register(BoardCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "boardCell")
        
        newsCollectionView.register(FeedSafeEmptyCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "FeedSafeEmptyCollectionViewCell")
        
        newsCollectionView.isPagingEnabled = true
    }

}

extension FeedViewController: UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: newsCollectionView.frame.width,
                      height: newsCollectionView.frame.height)
    }
}
