//
//  ClubReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubReviewViewController: UIViewController {
    @IBOutlet weak var reviewTableView: UITableView!
    let pageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reviewTableView.dataSource = self
    }
}
