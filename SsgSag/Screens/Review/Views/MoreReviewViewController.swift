//
//  MoreReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

enum ReviewType {
    case SsgSag
    case Blog
}

class MoreReviewViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var registerReviewButton: UIButton!
    @IBOutlet weak var registerBlogButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var clubInfo: ClubInfo!
    var vcType: ReviewType!
    var service: ReviewServiceProtocol?
    var ssgSagCellModel: [ReviewInfo] = []
    var blogCellModel: [BlogInfo] = []
    var curPage = 0
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reviewEdit(_:)), name: NSNotification.Name(rawValue: "reviewEdit"), object: nil)
        
        service = ReviewService()
        titleLabel.text = "\(clubInfo.clubName)"
        setupTableView(type: vcType)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        curPage = 0
        removeCell(type: vcType)
        tableView.reloadData()
        setupDataWithType(type: vcType)
    }
    
    @objc func reviewEdit(_ notification: Notification) {
        // MARK: 수정 ActionSheet
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
           // MARK: 수정, 취소 Alert
            let alert = UIAlertController(title:
                "후기를 정말 수정하시겠습니까?", message:
                "후기 수정 시 재승인이 필요합니다.\n신중히 결정해주세요 😭", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "수정",style: .destructive) { _ in
                
                guard let reviewInfo = notification.object as? ReviewInfo else {return}
                let clubIdx = self.clubInfo.clubIdx
                let type: ClubType = self.clubInfo.clubType == 0 ? .Union : .School
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEditVC") as? ReviewEditViewController else {return}
                nextVC.reviewService = ReviewService()
                
                let clubactInfo = ClubActInfoModel(clubType: type)
                clubactInfo.clubIdx = clubIdx
                clubactInfo.clubName = self.clubInfo.clubName
                if type == .School {
                    clubactInfo.univName = self.clubInfo.univOrLocation
                } else {
                    clubactInfo.location.accept(self.clubInfo.univOrLocation)
                }
                clubactInfo.isExistClub = true
                
                nextVC.reviewEditViewModel = ReviewEditViewModel(clubActInfo: clubactInfo, reviewInfo: reviewInfo)
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            let cancelAction = UIAlertAction(title: "취소",style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
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
                self.service?.requestDeleteReview(clubPostIdx: postIdx) { isSuccess in
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
            self.present(alert, animated: true)
        }
        // MARK: 신고 ActionSheet
        let reportAction = UIAlertAction(title: "신고", style: .default) { _ in
            
        }
        // MARK: 취소 ActionSheet
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        self.simpleActionSheet(title: "하실 작업을 선택해주세요.", actions: [editAction, deleteAction, cancelAction])
        
    }
    
    func removeCell(type: ReviewType) {
        type == .SsgSag ? ssgSagCellModel.removeAll() : blogCellModel.removeAll()
    }
    
    func setupTableView(type: ReviewType) {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 428
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        
        if type == .SsgSag {
            tableView.allowsSelection = false
            registerReviewButton.isHidden = false
            let nib = UINib(nibName: "SsgSagReviewTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "SsgSagReviewCell")
        } else {
            tableView.allowsSelection = true
            registerBlogButton.isHidden = false
            let nib = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "BlogReviewCell")
        }
    }
    
    func setupDataWithType(type: ReviewType) {
        // MARK: 슥삭후기
        indicator.startAnimating()
        if type == .SsgSag {
            service?.requestReviewList(clubIdx: clubInfo.clubIdx, curPage: curPage) { datas in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                guard let datas = datas else {return}
                if datas.count == 0 {
                    self.curPage -= 1
                    return
                }
                self.ssgSagCellModel += datas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
            }
        // MARK: 블로그 후기
        } else {
            service?.requestBlogReviewList(clubIdx: clubInfo.clubIdx, curPage: curPage) { datas in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                guard let datas = datas else {return}
                if datas.count == 0 {
                    self.curPage -= 1
                    return
                }
                self.blogCellModel += datas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
            }
        }
    }
    
    //후기통신, 블로그통신
    //블로그/후기 쓰기버튼
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewWriteClick(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewPrepareVC") as? UINavigationController else {return}
        guard let nextVC = navigationVC.topViewController as? ReviewPrepareViewController else {return}
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
    
    @IBAction func blogWriteClick(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBlogReviewVC") as? UINavigationController else {return}
        
        guard let nextVC = navigationVC.topViewController as? RegisterBlogReviewViewController else {return}
        
        nextVC.clubIdx = clubInfo.clubIdx
        nextVC.service = service
        
        self.present(navigationVC, animated: true)
    }
}
