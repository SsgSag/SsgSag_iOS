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
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreReviewTopLabelCell", for: indexPath) as! MoreReviewTopLabelTableViewCell
            cell.reviewCountLabel.text = "후기 총 \(clubInfo.scoreNum)개"
            
            return cell
        } else {
            if vcType == ReviewType.SsgSag {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SsgSagReviewCell", for: indexPath) as! SsgSagReviewTableViewCell
                cell.bind(model: ssgSagCellModel[indexPath.row])
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogReviewCell", for: indexPath) as! BlogReviewTableViewCell
                
                return cell
            }
        }
    }
}
