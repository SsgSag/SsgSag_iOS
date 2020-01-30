//
//  NormalReviewCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/29.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class NormalReviewTableViewCell: UITableViewCell {
    
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
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    var score: Float = -1
    var onClick = false
    
    var viewModel: ReviewInfo! {
        willSet {
            //
            //
            //
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
    
    @IBAction func moreViewClick(_ sender: Any) {
       
        onClick = !onClick
        
        self.moreButton.isHidden = onClick
        
        
    }
   
    @IBAction func likeClick(_ sender: Any) {
    }
}
