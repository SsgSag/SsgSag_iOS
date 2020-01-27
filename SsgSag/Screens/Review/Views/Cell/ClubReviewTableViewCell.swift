//
//  ClubReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/26.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratePaint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ratePaint() {
        let stackStar: [UIImageView] = [star1 , star2, star3, star4, star5]
        var score = 3.9
        
        stackStar.forEach {
            score -= 1
            if score >= 0 {
                $0.image = self.fullStar
            } else if score > -1 {
                $0.image = self.halfStar
            }
        }
        
    }

    @IBAction func moreReviewClick(_ sender: Any) {
        //next view
    }
}
