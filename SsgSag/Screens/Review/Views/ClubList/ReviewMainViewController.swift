//
//  ReviewMainViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewMainViewController: UIViewController {
    typealias TabModel = ReviewTabCellModel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    var mainType: MainType!
    var tabTitle: [TabModel] = []
    let cellModel: BehaviorRelay<[ReviewTabCellModel]> = BehaviorRelay(value: [])
    var reviewPageInstance: ReviewPageViewController!
    var focusIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    var curIndex = 0
    private let maxPopupCount = 5
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tabCollectionView.delegate = self
        
        switch mainType {
        case .club:
            titleLabel.text = "동아리 후기"
            bindData()
        case .activity:
            titleLabel.text = "대외활동 후기"
            tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
            tabCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        case .intern:
            titleLabel.text = "인턴 후기"
            tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
            tabCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        default:
            tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
            tabCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        popupPresent()
        cellModel.accept(tabTitle)
        UnivName.shared.requestUnivList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindData() {
        let sub = reviewPageInstance.subViewControllers
        
        cellModel.bind(to: tabCollectionView.rx.items(cellIdentifier: "ReviewPageCell")) { [weak self] (indexPath, cellViewModel, cell) in
            
            guard let cell = cell as? ReviewPageCollectionViewCell else {return}
            guard let cellModel = self?.cellModel.value else {return}
            cell.bind(model: cellModel, index: indexPath)
        
        }.disposed(by: disposeBag)
        
        tabCollectionView
            .rx
            .itemSelected
            .do(onNext: { [weak self] index in
                self?.focusIndex.onNext(index.item)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        
        // 클릭한 인덱스에 따라서 페이지이동
        focusIndex
            .subscribe(onNext: { [weak self] index in
                guard let curIndex = self?.curIndex else {return}
                guard curIndex != index else { return }
                
                self?.cellModel.value.forEach{$0.onFocus = false}
                self?.cellModel.value[index].onFocus = true
                guard let cellModelList = self?.cellModel.value else {return}
                self?.cellModel.accept(cellModelList)
                
                let direction: UIPageViewController.NavigationDirection! = curIndex < index ? .forward : .reverse
                self?.reviewPageInstance.setViewControllers([sub[index]], direction: direction , animated: true, completion: nil)
                self?.curIndex = index
              
            })
            .disposed(by: disposeBag)
    }
    
    func popupPresent() {
        let popupCount = UserDefaults.standard.integer(forKey: "isEventPopup")
        if popupCount > maxPopupCount {
            return
        }
        let popupVC = UIStoryboard(name: "ReviewEvent", bundle: nil).instantiateViewController(withIdentifier: "mainPopUpVC")
        UserDefaults.standard.set(popupCount+1, forKey: "isEventPopup")
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
        let type: ClubType = curIndex == 1 ? .Union : .School
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
        
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        present(myPageViewNavigator,
                animated: true)
    }
}

extension ReviewMainViewController: UIGestureRecognizerDelegate {}
