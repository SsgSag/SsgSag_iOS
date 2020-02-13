//
//  ReviewMainViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ReviewMainViewController: UIViewController {
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    typealias TabModel = ReviewTabCellModel
    var tabTitle = [ TabModel(title: "교내 동아리", onFocus: true),
                     TabModel(title: "연합 동아리", onFocus: false)
                    ]
    var reviewPageInstance: ReviewPageViewController!
    var focusIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    var curIndex = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tabCollectionView.dataSource = self
        self.tabCollectionView.delegate = self
        self.tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        bindData()
        popUpPresent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindData() {
        let sub = reviewPageInstance.subViewControllers
        
        // 클릭한 인덱스에 따라서 페이지이동
        focusIndex.subscribe(onNext: { index in
            guard self.curIndex != index else { return }
            
            let direction: UIPageViewController.NavigationDirection! = self.curIndex < index ? .forward : .reverse
            self.reviewPageInstance.setViewControllers([sub[index]], direction: direction , animated: true, completion: nil)
            self.curIndex = index
            })
        .disposed(by: disposeBag)
    }
    
    func popUpPresent() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "mainPopUpVC") else {return}
        self.present(popupVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ContainerView Instance설정
        if segue.identifier == "ReviewPageSegue" {
            self.reviewPageInstance = segue.destination as? ReviewPageViewController
            reviewPageInstance.pageDelegate = self
        }
    }
    
    @IBAction func searchButtoClickn(_ sender: Any) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewSearch") as? ReviewSearchViewController else {return}
        let type: ClubType = curIndex == 0 ? .Union : .School
        nextVC.viewModel = ReviewSearchViewModel(clubType: type, service: ClubService())
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func writeReviewClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewPrepareVC") else {return}
        self.present(nextVC, animated: true)
        
    }
    
    @IBAction func registerClubClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectClubManagerVC") else {return}
        self.present(nextVC, animated: true)
    }
    
    @IBAction func mypageClick(_ sender: Any) {
        let storyBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        guard let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyPageVC") as? MyPageViewController else {return}
        self.present(nextVC, animated: true)
    }
}

extension ReviewMainViewController: UIGestureRecognizerDelegate {}
