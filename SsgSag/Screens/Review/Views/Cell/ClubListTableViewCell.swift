//
//  ClubReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/26.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubListTableViewCell: UITableViewCell {

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
    @IBOutlet weak var clubDetailButton: UIButton!
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    var score: Float = -1
    var delegate: ClubListSelectDelgate!
    var viewModel: ClubListData! {
        willSet {
            self.reviewCountLabel.text = newValue.categoryList
            self.titleLabel.text = newValue.clubName
            self.descriptionLabel.text = newValue.oneLine
            self.scoreLabel.text = "평점 \(newValue.aveScore)"
            self.score = newValue.aveScore
            self.reviewCountLabel.text = "후기 20개"
            self.categoryLabel.text = newValue.categoryList
            self.categoryLabel.sizeToFit()
            
            ratePaint()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func ratePaint() {
        let stackStar: [UIImageView] = [star1 , star2, star3, star4, star5]
    
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

    @IBAction func moreReviewClick(_ sender: Any) {
        delegate.clubDetailClick(clubIdx: viewModel.clubIdx)
    }
}
