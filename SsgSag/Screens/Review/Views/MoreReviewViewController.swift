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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func removeCell(type: ReviewType) {
        type == .SsgSag ? ssgSagCellModel.removeAll() : blogCellModel.removeAll()
    }
    
    func setupTableView(type: ReviewType) {
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 428
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        
        if type == .SsgSag {
            registerReviewButton.isHidden = false
            let nib = UINib(nibName: "SsgSagReviewTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "SsgSagReviewCell")
        } else {
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
                
                guard let datas = datas else {return}
                if datas.count == 0 {
                    self.curPage -= 1
                    return
                }
                self.ssgSagCellModel += datas
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        // MARK: 블로그 후기
        } else {
            service?.requestBlogReviewList(clubIdx: clubInfo.clubIdx, curPage: curPage) { datas in
                guard let datas = datas else {return}
                if datas.count == 0 {
                    self.curPage -= 1
                    return
                }
                self.blogCellModel += datas
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
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
