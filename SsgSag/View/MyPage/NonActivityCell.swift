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
    
    var careerInfo: careerData? {
        didSet {
            guard let career = self.careerInfo else {return}
            
            titleLabel.text = career.careerName
            dateLabel1.text = career.careerDate1
            detailLabel.text = career.careerContent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
