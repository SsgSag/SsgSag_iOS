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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if vcType == ReviewType.SsgSag {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SsgSagReviewCell", for: indexPath) as! SsgSagReviewTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogReviewCell", for: indexPath) as! BlogReviewTableViewCell
            
            return cell
        }
    }
}
