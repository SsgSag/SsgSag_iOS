//
//  ClubDetailViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClubDetailViewController: UIViewController {
    
    @IBOutlet weak var friendDegreeLabel: UILabel!
    @IBOutlet weak var hardDegreeLabel: UILabel!
    @IBOutlet weak var funDegreeLabel: UILabel!
    @IBOutlet weak var proDegreeLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var oneLineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLineView: UIView!
    @IBOutlet weak var infoLineView: UIView!
    @IBOutlet weak var clubReviewButton: UIButton!
    @IBOutlet weak var clubInfoButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var clubIdx = -1
    var clubCategorySet: [String] = []
    var clubCategoryList = ""
    let tabString = ["정보", "후기"]
    let tabViewModel = ClubDetailViewModel.shared
    var disposeBag: DisposeBag!
    var clubPageInstance: ClubPageViewController!
    var curPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        disposeBag = DisposeBag()
        bind()
        requestClubInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         tabBarController?.tabBar.isHidden = false
    }
    
    func setupDefault() {
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        self.clubReviewButton.frame.size.width = self.view.frame.width/2
        self.clubInfoButton.frame.size.width = self.view.frame.width/2
        self.view.layoutIfNeeded()
        setupCategoryList()
    }
    
    // 카테고리String 분리
    func setupCategoryList() {
        self.clubCategoryList = "연합,IT/공학,디자인,기획/전략"
        self.clubCategorySet = clubCategoryList.removeComma()
        self.categoryCollectionView.reloadData()
    }
    
    func bind() {
        self.tabViewModel.tabPageObservable
            .observeOn( MainScheduler.instance )
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] page in
                
                guard self?.curPage != page else { return }
                guard let sub = self?.clubPageInstance.subViewControllers else { return }
                
                let direction: UIPageViewController.NavigationDirection! = self!.curPage < page ? .forward : .reverse
                self?.clubPageInstance.setViewControllers([sub[page]], direction: direction , animated: true, completion: nil)
                self?.curPage = page
                if page == 0 {
                    self?.tabViewModel.setButton(select: true)
                } else if page == 1 {
                   self?.tabViewModel.setButton(select: false)
                }
            })
            .disposed(by: disposeBag)
        
        self.tabViewModel.tabFirstButtonStatus
            .observeOn( MainScheduler.instance )
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] b in
                self?.clubInfoButton.isSelected = b
                self?.clubReviewButton.isSelected = !b
                
                if b {
                    self?.infoLineView.backgroundColor = #colorLiteral(red: 0.376783371, green: 0.4170111418, blue: 1, alpha: 1)
                    self?.reviewLineView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                    self?.tabViewModel.setPage(page: 0)
                }else {
                    self?.infoLineView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                    self?.reviewLineView.backgroundColor = #colorLiteral(red: 0.376783371, green: 0.4170111418, blue: 1, alpha: 1)
                    self?.tabViewModel.setPage(page: 1)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func requestClubInfo() {
        DispatchQueue.global().async {
            ClubService().requestClubInfo(clubIdx: self.clubIdx) { data in
                guard data != nil else {return}
                
                /*
                 평점
                 성격정도 바인딩하기
                 */
                
                self.tabViewModel.setData(data: data!)
            }
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPageSegue" {
            self.clubPageInstance = segue.destination as? ClubPageViewController
            self.clubPageInstance.tabViewModel = self.tabViewModel
        }
    }
    
    @IBAction func reviewWrite(_ sender: Any) {
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewClick(_ sender: Any) {
        self.tabViewModel.tabFirstButtonStatus.onNext(false)
    }
    
    @IBAction func infoClick(_ sender: Any) {
        self.tabViewModel.tabFirstButtonStatus.onNext(true)
    }
    
    deinit {
        print("memory - detail 종료")
    }
}
