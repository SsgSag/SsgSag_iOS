//
//  DayCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var todoTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }
    
    private func setupTableView() {
        todoTableView.separatorStyle = .none
    }
    
}
