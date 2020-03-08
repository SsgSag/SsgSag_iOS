//
//  BlogReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import Kingfisher

class BlogReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var createNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bind(_ blog: BlogInfo) {
        titleLabel.text = blog.blogTitle
        contentLabel.text = blog.blogDescription
        let nickName = blog.blogNickname
        let regDate = blog.blogRegDate
        createNameLabel.text = "\(nickName) | \(regDate)"
    
        if let imgUrlString = blog.blogImageUrl {
            let imgUrl = URL(string: imgUrlString)
            imgView.kf.setImage(with: imgUrl, options: [.transition(.fade(0.2)), .cacheOriginalImage])
        } else {
            imgView.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = 0
                }
            }
            
            createNameLabel.constraints.forEach{ constraint in
                if constraint.firstAttribute == .bottomMargin {
                    constraint.constant = 16
                }
            }
        }
    }
}
