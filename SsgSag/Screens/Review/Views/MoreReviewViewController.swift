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
    
    @IBOutlet weak var registerReviewButton: UIButton!
    @IBOutlet weak var registerBlogButton: UIButton!
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var clubInfo: ClubInfo!
    var vcType: ReviewType!
    var service: ReviewServiceProtocol?
    var ssgSagCellModel: [ReviewInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ReviewService()
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 428
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        setupDataWithType(type: vcType)
    }
    
    func setupDataWithType(type: ReviewType) {
        if type == .SsgSag {
            titleLabel.text = "\(clubInfo.clubName)"
            registerReviewButton.isHidden = false
            let nib = UINib(nibName: "SsgSagReviewTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "SsgSagReviewCell")
            
            //페이징처리하기
            service?.requestReviewList(clubIdx: clubInfo.clubIdx, curPage: 0) { datas in
                guard let datas = datas else {return}
                self.ssgSagCellModel = datas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        } else {
            titleLabel.text = "\(clubInfo.clubName) 블로그 후기"
            registerBlogButton.isHidden = false
            let nib = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "BlogReviewCell")
        }
    }
    
    //후기,블로그 등록타입구분
    //후기통신, 블로그통신
    //블로그/후기 쓰기버튼
    //타이틀 바꾸기
    
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
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBlogReviewVC") else {return}
        
        self.present(nextVC, animated: true)
    }
}
