//
//  ClubReviewVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/26.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TableDataSource
extension ClubSchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClubCell", for: indexPath) as! ClubListTableViewCell
        
        cell.viewModel = cellData[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - Table Delegate
extension ClubSchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.cellData.count-1 {
            self.curPage += 1
            self.requestPage()
        }
    }
}

// MARK: - Extension
extension ClubSchoolListViewController: ClubListSelectDelgate {
    func clubDetailClick(clubIdx: Int) {
          let nextVC = UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubDetailVC") as! ClubDetailViewController
              nextVC.clubIdx = clubIdx
        nextVC.tabViewModel = ClubDetailViewModel()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
