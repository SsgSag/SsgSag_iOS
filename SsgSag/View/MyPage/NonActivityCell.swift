//
//  NonActivityCell.swift
//  SsgSag
//
//  Created by CHOMINJI on 31/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NonActivityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel1: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
