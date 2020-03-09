//
//  MoreReviewVC+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import UIKit

extension MoreReviewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        } else {
            if vcType == ReviewType.SsgSag {
                return ssgSagCellModel.count
            } else {
                return blogCellModel.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreReviewTopLabelCell", for: indexPath) as! MoreReviewTopLabelTableViewCell
            
            // 블로그 / 슥삭 후기개수 구분해주기
            if vcType == ReviewType.SsgSag {
                cell.reviewCountLabel.text = "후기 총 \(clubInfo.scoreNum)개"
            } else {
                cell.reviewCountLabel.text = "후기 총 \(clubInfo.blogPostNum)개"
            }
            
            return cell
        } else {
            if vcType == ReviewType.SsgSag {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SsgSagReviewCell", for: indexPath) as! SsgSagReviewTableViewCell
                cell.bind(model: ssgSagCellModel[indexPath.row])
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogReviewCell", for: indexPath) as! BlogReviewTableViewCell
                cell.bind(blogCellModel[indexPath.row])
                
                return cell
            }
        }
    }
}

extension MoreReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoading else {
            return
        }
        let cellCount = vcType == ReviewType.SsgSag ? ssgSagCellModel.count : blogCellModel.count
        if indexPath.row == cellCount-1 {
            isLoading = true
            self.curPage += 1
            self.setupDataWithType(type: vcType)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vcType == ReviewType.Blog {
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
