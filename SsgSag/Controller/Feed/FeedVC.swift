//
//  FeedVC.swift
//  SsgSag
//
//  Created by 이혜주 on 11/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    @IBOutlet weak var menuBar: MenuBar!
    
    var selectedMenuIndex: Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        menuBar.menuCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        setupCollectionView()
    }
    
    @IBAction func touchUpMyPageButton(_ sender: UIButton) {
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        present(myPageViewController, animated: true)
    }
    
    private func setupMenuBar() {
        menuBar.feedVC = self
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell",
                                                     for: indexPath) as? FeedPageCollectionViewCell else {
                                                        return .init()
            }
            
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: newsCollectionView.frame.width, height: newsCollectionView.frame.height)
    }
}

extension FeedVC: MenuBarDelegate {
    func getSelectedMenu(index: Int) {
        selectedMenuIndex = index
    }
}

extension FeedVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x / 2 - 48)
//        menuBar.horizontalBarViewLeadingConstraint?.constant = scrollView.contentOffset.x / 2 - 48
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.menuCollectionView.selectItem(at: indexPath,
                                              animated: true,
                                              scrollPosition: .left)
    }
}
