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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vcType == ReviewType.SsgSag {
            return ssgSagCellModel.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
