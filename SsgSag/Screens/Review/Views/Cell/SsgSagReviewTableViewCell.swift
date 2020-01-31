//
//  SsgSagReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SsgSagReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activeYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var advantageLabel: UILabel!
    @IBOutlet weak var disAdvantageLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var honeyTipLabel: UILabel!
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    var score: Float = -1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratePaint()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ratePaint() {
    
        score = 3.9
        let stackStar = self.starStackView.subviews as! [UIImageView]
        
        stackStar.forEach {
            score -= 1
            if score >= 0 {
                $0.image = self.fullStar
            } else if score > -1 {
                $0.image = self.halfStar
            } else {
                $0.image = self.blackStar
            }
        }
    }
    
    @IBAction func likeClick(_ sender: Any) {
    }
    
    @IBAction func editClick(_ sender: Any) {
    }
}
