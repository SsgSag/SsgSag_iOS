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
    
    lazy var fullStar = UIImage(named: "star2")
    lazy var halfStar = UIImage(named: "star1")
    lazy var blackStar = UIImage(named: "star0")
//    var score: Float = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bind(model: ReviewInfo) {
        userNameLabel.text = String(model.userIdx)
        let activeDate = model.clubEndDate.split(separator: "-").map{String($0)}
        activeYearLabel.text = activeDate[0]+"년 활동"
        titleLabel.text = model.oneLine
        advantageLabel.text = model.advantage
        disAdvantageLabel.text = model.disadvantage
        honeyTipLabel.text = model.honeyTip
        likeLabel.text = "\(model.likeNum)개"
        scoreLabel.text = "별점 \(model.score0)"
        self.ratePaint(score: Float(model.score0))
    }
    
    func ratePaint(score: Float) {
    
        let stackStar = self.starStackView.subviews as! [UIImageView]
        var score = score
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
