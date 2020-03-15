//
//  ClubReviewVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/29.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

extension ClubReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if normalReviewTableView == tableView {
            if reviewDataSet.count > 2 {
                return 3
            }
            return reviewDataSet.count
            
        } else {
            if blogDataSet.count > 2 {
                return 3
            }
            return blogDataSet.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if normalReviewTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalReviewCell", for: indexPath) as! NormalReviewTableViewCell
            
            cell.viewModel = self.reviewDataSet[indexPath.row]
            cell.bind()
            cell.ratePaint(score: self.reviewDataSet[indexPath.row].data.score0)
            cell.moreButton.tag = indexPath.row
            cell.moreButton.addTarget(self, action: #selector(moreViewSelect(sender:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogReviewCell", for: indexPath) as! BlogReviewTableViewCell
            
            cell.bind(blogDataSet[indexPath.row])
            return cell
        }
    }
}

extension ClubReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if normalReviewTableView == tableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? NormalReviewTableViewCell else {return}
            let onClick = self.reviewDataSet[indexPath.row].onClick
            self.reviewDataSet[indexPath.row].onClick = !onClick
            
            if onClick {
                cell.hideTipLabel()
            } else {
                cell.showTipLabel()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            // 블로그이동
            guard let cell = tableView.cellForRow(at: indexPath) as? BlogReviewTableViewCell else {return}
            guard let urlString = cell.model?.blogUrl else { return }
            guard let url = URL(string: urlString) else {
                self.simplerAlert(title: "잘못된 주소입니다.")
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.simplerAlert(title: "존재하지 않거나,\n잘못된 주소입니다.")
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
