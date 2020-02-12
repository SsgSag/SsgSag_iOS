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
    var tabViewModel: ClubDetailViewModel!
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
    
    lazy var blackStar = UIImage(named: "icStar0")
    lazy var fillStar = UIImage(named: "icStar2")
    
    override func viewWillAppear(_ animated: Bool) {
         tabBarController?.tabBar.isHidden = false
    }
    
    func setupDefault() {
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        self.clubReviewButton.frame.size.width = self.view.frame.width/2
        self.clubInfoButton.frame.size.width = self.view.frame.width/2
    }
    
    func bind() {
        tabViewModel.tabPageObservable
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
        
        tabViewModel.tabFirstButtonStatus
            .observeOn( MainScheduler.instance )
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] b in
                self?.clubInfoButton.isSelected = b
                self?.clubReviewButton.isSelected = !b
                
                if b {
                    self?.clubInfoButton.titleLabel?.font = UIFont.fontWithName(type: .semibold, size: 15)
                    self?.clubReviewButton.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
                    self?.infoLineView.backgroundColor = #colorLiteral(red: 0.376783371, green: 0.4170111418, blue: 1, alpha: 1)
                    self?.reviewLineView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                    self?.tabViewModel.setPage(page: 0)
                }else {
                    self?.clubInfoButton.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
                    self?.clubReviewButton.titleLabel?.font = UIFont.fontWithName(type: .semibold, size: 15)
                    self?.infoLineView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                    self?.reviewLineView.backgroundColor = #colorLiteral(red: 0.376783371, green: 0.4170111418, blue: 1, alpha: 1)
                    self?.tabViewModel.setPage(page: 1)
                }
            })
            .disposed(by: disposeBag)
        
        tabViewModel.proObservable
            .subscribe(onNext: { [weak self] scoreText in
                self?.proDegreeLabel.text = scoreText
            })
        .disposed(by: disposeBag)
        
        tabViewModel.funObservable
            .subscribe(onNext: { [weak self] scoreText in
                self?.funDegreeLabel.text = scoreText
            })
        .disposed(by: disposeBag)
        
        tabViewModel.hardObservable
            .subscribe(onNext: { [weak self] scoreText in
                self?.hardDegreeLabel.text = scoreText
            })
        .disposed(by: disposeBag)
        
        tabViewModel.friendObservable
            .subscribe(onNext: { [weak self] scoreText in
                self?.friendDegreeLabel.text = scoreText
            })
        .disposed(by: disposeBag)
        
        tabViewModel.recommendObservable
            .subscribe(onNext: { [weak self] scoreNum in
                self?.scoreLabel.text = "평점 \(scoreNum)"
                var score = scoreNum
                if let starImgs = self?.starStackView.subviews as? [UIImageView ] {
                    
                    starImgs.forEach{ score -= 1
                        if score < 0 {
                            ///수정하기
                            $0.image = self?.blackStar
                        } else{
                            $0.image = self?.fillStar
                        }
                        
                        
                    }
                }
            })
        .disposed(by: disposeBag)
    
    }
    
    func requestClubInfo() {
        
        ClubService().requestClubInfo(clubIdx: self.clubIdx) { data in
            guard let data = data else {return}
            
            self.titleLabel.text = data.clubName
            self.oneLineLabel.text = data.oneLine
            self.scoreCountLabel.text = "평점(\(data.score0sum)개)"
            self.scoreLabel.text = "(\(data.aveScore0)/5.0)"
            self.clubCategorySet = data.categoryList.removeComma()
            self.tabViewModel.setData(data: data)
            self.categoryCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPageSegue" {
            self.clubPageInstance = segue.destination as? ClubPageViewController
            self.clubPageInstance.tabViewModel = self.tabViewModel
        }
    }
    
    @IBAction func reviewWrite(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewPrepareVC") as? UINavigationController else {return}
        guard let nextVC = navigationVC.topViewController as? ReviewPrepareViewController else {return}
        guard let clubInfo = try? tabViewModel.clubInfoData.value() else {return}
        let type: ClubType = clubInfo.clubType == 0 ? .Union : .School
        let clubactInfo = ClubActInfoModel(clubType: type)
        nextVC.isExistClub = true
        clubactInfo.isExistClub = true
        clubactInfo.clubName = clubInfo.clubName
        clubactInfo.clubIdx = clubInfo.clubIdx
        let location = clubInfo.univOrLocation
        clubactInfo.location.accept(location)
        
        nextVC.clubactInfo = clubactInfo
        
        self.present(navigationVC, animated: true)
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
    
    @IBAction func popupClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewScorePopUpVC") else {return}
        self.present(nextVC, animated: true)
    }
    deinit {
        print("memory - detail 종료")
    }
}
