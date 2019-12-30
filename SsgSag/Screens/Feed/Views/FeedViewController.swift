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
        setNavigationBar(color: .white)
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return
        }
  
        if !isTryWithoutLogin {
            exitButton.setImage(UIImage(named: "bookmarkMenu"), for: .normal)
            exitButton.setTitle("", for: .normal)
        }
        newsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bind(viewModel: FeedViewModel())
    }
    
    func bind(viewModel: FeedViewModel) {
        
        let isNotLoggedIn = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool
        
        exitButton
            .rx
            .tap
            .withLatestFrom(Observable.just(isNotLoggedIn ?? true))
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
                        articleVC.articleTitle = self?.title ?? ""
                        articleVC.articleUrlString = cellViewModel.feed.feedUrl ?? ""
                        articleVC.feedIdx = cellViewModel.feed.feedIdx ?? 0
                        articleVC.isSave = cellViewModel.feed.isSave ?? 0

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

//extension FeedViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let safeEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedSafeEmptyCollectionViewCell", for: indexPath)
//        let page = FeedPageType(at: indexPath)
//        switch page {
//        case .recommendedNews:
//            guard let cell
//                = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell",
//                                                     for: indexPath)
//                    as? FeedPageCollectionViewCell else {
//                                                        return safeEmptyCell
//            }
//            return cell
//        default:
//            return safeEmptyCell
//        }
//    }
//        if indexPath.row == 0 {
//            guard let cell
//                = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell",
//                                                     for: indexPath) as? FeedPageCollectionViewCell else {
//                                                        return .init()
//            }
            
//            cell.delegate = self
//            cell.lookAroundCallback = { [weak self] in
//                self?.simpleAlertwithHandler(title: "북마크",
//                                       message: "해당 기능을 이용하려면\n회원가입을 진행해주세요") { _ in
//                       KeychainWrapper.standard.removeObject(forKey: TokenName.token)
//
//                       guard let window = UIApplication.shared.keyWindow else {
//                           return
//                       }
//
//                       let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
//                       let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
//
//                       let rootNavigationController = UINavigationController(rootViewController: viewController)
//
//                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                       appDelegate.window?.rootViewController = rootNavigationController
//
//                       rootNavigationController.view.layoutIfNeeded()
//
//                       UIView.transition(with: window,
//                                         duration: 0.5,
//                                         options: .transitionFlipFromLeft,
//                                         animations: {
//                           window.rootViewController = rootNavigationController
//                       }, completion: nil)
//
//                       return
//                   }
//            }
//
//            return cell
//        } else {
//            guard let cell
//                = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCell",
//                                                     for: indexPath) as? BoardCollectionViewCell else {
//                                                        return .init()
//            }
//
//            return cell
//        }
        
    
//}

extension FeedViewController: UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: newsCollectionView.frame.width,
                      height: newsCollectionView.frame.height)
    }
}

extension FeedViewController: FeedTouchDelegate {
    func touchUpFeedCell(title: String, feedIdx: Int, urlString: String, isSave: Int) {

        let adBrix = AdBrixRM.getInstance
        adBrix.event(eventName: "touchUp_FeedNews",
                     value: ["feedUrl": urlString])
        
        let articleVC = ArticleViewController()
        articleVC.articleTitle = title
        articleVC.articleUrlString = urlString
        articleVC.feedIdx = feedIdx
        articleVC.isSave = isSave
        articleVC.callback = { [weak self] in
            guard let cell = self?.newsCollectionView.cellForItem(at: IndexPath(item: 0,
                                                                                section: 0))
                as? FeedPageCollectionViewCell else {
                return
            }
            
            cell.feedDatas = []
           // cell.requestFeed()
        }
        navigationController?.pushViewController(articleVC,
                                                 animated: true)
    }
}
