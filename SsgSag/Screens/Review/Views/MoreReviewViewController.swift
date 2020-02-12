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
    
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
            self.titleLabel.text = "슥삭 후기"
            let nib = UINib(nibName: "SsgSagReviewTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "SsgSagReviewCell")
            
            //페이징처리하기
            service?.requestReviewList(clubIdx: 10, curPage: 0) { datas in
                guard let datas = datas else {return}
                self.ssgSagCellModel = datas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        } else {
            self.titleLabel.text = "블로그 후기"
            let nib = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "BlogReviewCell")
        }
    }
    
    //후기,블로그 등록타입구분
    //후기통신, 블로그통신
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewWriteClick(_ sender: Any) {
        
    }
}
