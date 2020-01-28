//
//  ClubReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubListViewController: UIViewController {
    @IBOutlet weak var reviewTableView: UITableView!
    let pageIndex = 0
    internal var curPage = 0
    var cellData: [ClubListData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reviewTableView.dataSource = self
        self.reviewTableView.delegate = self
        requestPage()
    }
    
    func requestPage() {
        ClubService.shared.requestClubList(curPage: curPage) { data in
            guard data != nil else { return }
            data!.forEach { self.cellData.append($0) }
            self.reviewTableView.reloadData()
        }
    }
}
