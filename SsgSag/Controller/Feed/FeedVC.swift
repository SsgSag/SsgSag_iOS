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

class FeedVC: UIViewController {
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
    var selectedMenuIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        setNavigationBar(color: .white)
        
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return
        }
        
        if !isTryWithoutLogin {
            exitButton.setImage(#imageLiteral(resourceName: "ic_bookmarkMenu"), for: .normal)
            exitButton.setTitle("", for: .normal)
        }
        
        newsCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//        menuBar.menuCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    @IBAction func touchUpExitButton(_ sender: Any) {
        if exitButton.titleLabel?.text != "나가기" {
            navigationController?.pushViewController(ScrapViewController(), animated: true)
            return
        }
        
        KeychainWrapper.standard.removeObject(forKey: TokenName.token)
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
        
        let rootNavigationController = UINavigationController(rootViewController: viewController)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootNavigationController
        
        rootNavigationController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = rootNavigationController
        }, completion: nil)
    }
    
    @IBAction func touchUpMyPageButton(_ sender: UIButton) {
        if let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool {
            if isTryWithoutLogin {
                simpleAlertwithHandler(title: "마이페이지", message: "로그인 후 이용해주세요") { _ in
                    
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
                    
                    let rootNavigationController = UINavigationController(rootViewController: viewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = rootNavigationController
                    
                    rootNavigationController.view.layoutIfNeeded()
                    
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        window.rootViewController = rootNavigationController
                    }, completion: nil)
                }
                return
            }
        }
        
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        
        present(myPageViewNavigator,
                animated: true)
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
        
        newsCollectionView.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        newsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

}

extension FeedVC: UICollectionViewDelegate {
    
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell",
                                                     for: indexPath) as? FeedPageCollectionViewCell else {
                                                        return .init()
            }
            
            cell.delegate = self
            
            return cell
        } else {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCell",
                                                     for: indexPath) as? BoardCollectionViewCell else {
                                                        return .init()
            }
            
            return cell
        }
        
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: newsCollectionView.frame.width,
                      height: newsCollectionView.frame.height)
    }
}

extension FeedVC: MenuBarDelegate {
    func getSelectedMenu(index: Int) {
        selectedMenuIndex = index
    }
}

extension FeedVC: FeedTouchDelegate {
    func touchUpFeedCell(title: String, feedIdx: Int, urlString: String, isSave: Int) {

        let adBrix = AdBrixRM.getInstance
        adBrix.event(eventName: "touchUp_FeedNews",
                     value: ["feedUrl": urlString])
        
        let articleVC = ArticleViewController()
        articleVC.articleTitle = title
        articleVC.articleUrlString = urlString
        articleVC.feedIdx = feedIdx
        articleVC.isSave = isSave
        navigationController?.pushViewController(articleVC,
                                                 animated: true)
    }
}

extension FeedVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x / 2 - 48)
//        menuBar.horizontalBarViewLeadingConstraint?.constant = scrollView.contentOffset.x / 2 - 48
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let index = targetContentOffset.pointee.x / view.frame.width
//
//        let indexPath = IndexPath(item: Int(index), section: 0)
//        menuBar.menuCollectionView.selectItem(at: indexPath,
//                                              animated: true,
//                                              scrollPosition: .left)
    }
}
