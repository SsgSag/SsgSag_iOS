//
//  NormalReviewCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/29.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class NormalReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeImgTopLayout: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activeYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var advantageLabel: UILabel!
    @IBOutlet weak var disAdvantageLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var honeyLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var honeyTipLabel: UILabel!
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    var score: Float = -1
    
    var viewModel: ReviewCellInfo! {
        willSet {
            if newValue.onClick {
                showTipLabel()
            } else {
                setup()
            }
        }
    }
    
    override func awakeFromNib() {
        ratePaint()
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
    
    func setup() {
        self.moreButton.isHidden = false
        self.honeyLabel.isHidden = true
        self.honeyTipLabel.isHidden = true
        self.likeImgTopLayout.constant = 22
    }
    
    func showTipLabel() {
        self.moreButton.isHidden = true
        self.honeyLabel.isHidden = false
        self.honeyTipLabel.isHidden = false
        
        let size = CGSize(width: self.frame.width, height: .infinity)
        let height = honeyTipLabel.sizeThatFits(size).height
        // 기본22 라벨크기17 라벨과마진 15
        self.likeImgTopLayout.constant = 22 + 17 + 15 + height
    }

    @IBAction func moreViewClick(_ sender: Any) {
        showTipLabel()
    }
    
    @IBAction func likeClick(_ sender: Any) {
    }
    
    @IBAction func editClick(_ sender: Any) {
    }
}
