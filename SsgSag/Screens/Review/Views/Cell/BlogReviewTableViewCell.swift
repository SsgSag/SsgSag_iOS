//
//  BlogReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class BlogReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var createNameLabel: UILabel!
    @IBOutlet weak var thumbImgViewStack: UIStackView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
