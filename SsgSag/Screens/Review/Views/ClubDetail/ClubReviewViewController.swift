//
//  ClubReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift


class ClubReviewViewController: UIViewController {
    var tabViewModel: ClubDetailViewModel!
    var disposeBag: DisposeBag!
    var reviewDataSet: [ReviewCellInfo] = []
    var blogDataSet: [BlogInfo] = []
    
    @IBOutlet weak var blogCountLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var emptyBlogView: UIView!
    @IBOutlet weak var emptyReviewView: UIView!
    @IBOutlet weak var blogTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var reviewTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var normalReviewTableView: UITableView!
    @IBOutlet weak var blogReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshResizeTableView), name: NSNotification.Name(rawValue: "resizeTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reviewEdit(_:)), name: NSNotification.Name(rawValue: "reviewEdit"), object: nil)
        
        
        disposeBag = DisposeBag()
        tableViewSetup()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reviewEdit"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "resizeTableView"), object: nil)
    }
    
    func tableViewSetup() {
        normalReviewTableView.dataSource = self
        normalReviewTableView.delegate = self
        
        normalReviewTableView.estimatedRowHeight = 1500
        normalReviewTableView.rowHeight = UITableView.automaticDimension
        
        blogReviewTableView.dataSource = self
        blogReviewTableView.delegate = self
        let nibCell = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
        blogReviewTableView.register(nibCell, forCellReuseIdentifier: "BlogReviewCell")
        blogReviewTableView.estimatedRowHeight = 1500
        normalReviewTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func bind() {
        // MARK: 슥삭 후기
        self.tabViewModel.reviewDataSet
            .compactMap{ $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                
                if data.isEmpty {
                    self?.emptyReviewView.isHidden = false
                } else {
                    self?.emptyReviewView.isHidden = true
                }
                self?.reviewDataSet.removeAll()
                data.forEach {
                    self?.reviewDataSet.append(ReviewCellInfo(data: $0))
                }
                
                self?.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
                self?.normalReviewTableView.reloadData()
                self?.view.layoutIfNeeded()
                if let contentSize = self?.normalReviewTableView.contentSize.height {
                    self?.reviewTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
                }
                if let clubInfo = self?.tabViewModel.clubInfoData.value {
                    self?.reviewCountLabel.text = "\(clubInfo.scoreNum)"
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: 블로그 후기
        tabViewModel.blogDataSet
            .compactMap{$0}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] blogData in
                if blogData.isEmpty {
                    self?.emptyBlogView.isHidden = false
                } else {
                    self?.emptyBlogView.isHidden = true
                }
                self?.blogDataSet.removeAll()
                self?.blogDataSet = blogData
                
                self?.blogTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
                self?.blogReviewTableView.reloadData()
                self?.view.layoutIfNeeded()
                if let contentSize = self?.blogReviewTableView.contentSize.height {
                    self?.blogTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
                }
                if let clubInfo = self?.tabViewModel.clubInfoData.value {
                    self?.blogCountLabel.text = "\(clubInfo.blogPostNum)"
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: 더보기 누를시 resize
    @objc func refreshResizeTableView() {
        
        self.normalReviewTableView.beginUpdates()
        self.normalReviewTableView.endUpdates()
        self.view.layoutIfNeeded()
        self.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
        self.reviewTableHeightLayout.constant = self.normalReviewTableView.contentSize.height
    }
    
    // MARK: 옵션버튼클릭
    @objc func reviewEdit(_ notification: Notification) {
        // MARK: 수정 ActionSheet
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            // MARK: 수정, 취소 Alert
            let alert = UIAlertController(title:
                "후기를 정말 수정하시겠습니까?", message:
                "후기 수정 시 재승인이 필요합니다.\n신중히 결정해주세요 😭", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "수정",style: .destructive) { _ in
                
                guard let reviewInfo = notification.object as? ReviewInfo else {return}
                guard let clubInfo = self.tabViewModel.clubInfoData.value else {return}
                let clubIdx = clubInfo.clubIdx
                let type: ClubType = clubInfo.clubType == 0 ? .Union : .School
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEditVC") as? ReviewEditViewController else {return}
                nextVC.reviewService = ReviewService()
                
                let clubactInfo = ClubActInfoModel(clubType: type)
                clubactInfo.clubIdx = clubIdx
                clubactInfo.clubName = clubInfo.clubName
                if type == .School {
                    clubactInfo.univName = clubInfo.univOrLocation
                } else {
                    clubactInfo.location.accept(clubInfo.univOrLocation)
                }
                clubactInfo.isExistClub = true
                
                nextVC.reviewEditViewModel = ReviewEditViewModel(clubActInfo: clubactInfo, reviewInfo: reviewInfo)
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            let cancelAction = UIAlertAction(title: "취소",style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true)
            
        }
        // MARK: 삭제 ActionSheet
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { _ in
            
            // MARK: 삭제, 취소 Alert
            let alert = UIAlertController(title:
                "후기를 정말 삭제하시겠습니까?", message:
                "삭제된 후기는 복구가 불가능합니다. 신중히 결정해주세요 😭", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제",style: .destructive) { _ in
                guard let reviewInfo = notification.object as? ReviewInfo else {return}
                let postIdx = reviewInfo.clubPostIdx
                self.tabViewModel.reviewService.requestDeleteReview(clubPostIdx: postIdx) { isSuccess in
                    DispatchQueue.main.async {
                        if isSuccess {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteViewController
                            nextVC.titleText = "삭제가\n완료되었습니다 :)"
                            nextVC.isEditMode = true
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        } else {
                            self.simplerAlert(title: "다시 시도해주세요.")
                        }
                    }
                    
                }
            }
            let cancelAction = UIAlertAction(title: "취소",style: .cancel)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true)
        }
        // MARK: 신고 ActionSheet
        let reportAction = UIAlertAction(title: "신고", style: .default) { _ in
            
        }
        // MARK: 취소 ActionSheet
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        self.simpleActionSheet(title: "하실 작업을 선택해주세요.", actions: [editAction, deleteAction, cancelAction])
        
    }
    
    
    @objc func moreViewSelect(sender: UIButton) {
        self.reviewDataSet[sender.tag].onClick = true
        
    }
    
    @IBAction func moreReviewClick(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreReviewVC") as! MoreReviewViewController
        let type: ReviewType = sender.tag == 1 ? .SsgSag : .Blog
        nextVC.vcType = type
        guard let clubInfo = tabViewModel.clubInfoData.value else {return}
        nextVC.clubInfo = clubInfo
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func registerReview(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewPrepareVC") as? UINavigationController else {return}
        guard let nextVC = navigationVC.topViewController as? ReviewPrepareViewController else {return}
        guard let clubInfo = tabViewModel.clubInfoData.value else {return}
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
    
    @IBAction func registerBlog(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBlogReviewVC") as? UINavigationController else {return}
        
        guard let nextVC = navigationVC.topViewController as? RegisterBlogReviewViewController else {return}
        guard let clubIdx = tabViewModel.clubInfoData.value?.clubIdx else {return}
        
        nextVC.clubIdx = clubIdx
        nextVC.service = tabViewModel.reviewService
        
        self.present(navigationVC, animated: true)
    }
    
    deinit {
        print("memory - review 종료")
    }
    
}
