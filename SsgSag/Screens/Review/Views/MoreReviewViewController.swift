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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 428
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if vcType == ReviewType.SsgSag {
            self.titleLabel.text = "슥삭 후기"
            let nib = UINib(nibName: "SsgSagReviewTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "SsgSagReviewCell")
            
        } else if vcType == ReviewType.Blog {
            self.titleLabel.text = "블로그 후기"
            let nib = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "BlogReviewCell")
        }
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewWriteClick(_ sender: Any) {
        
    }
}
