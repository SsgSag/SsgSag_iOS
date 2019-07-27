//
//  CommentCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    @IBOutlet weak var commentNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func touchUpLikeButton(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "ic_like") {
            // TODO: 좋아요수 줄일것
            sender.setImage(UIImage(named: "ic_likePassive"), for: .normal)
        } else {
            // TODO: 좋아요수 증가시킬것
            sender.setImage(UIImage(named: "ic_like"), for: .normal)
        }
    }
    
    @IBAction func touchUpEtcButton(_ sender: UIButton) {
        //TODO: alert 띄울것
    }
    
    func configure(comment: CommentList) {
        if let photoURL = comment.userProfileUrl {
            if let url = URL(string: photoURL){
                ImageNetworkManager.shared.getImageByCache(imageURL: url) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }
        }
        
        nameLabel.text = comment.userNickname
        dateLabel.text = comment.commentRegDate
        commentLabel.text = comment.commentContent
        likeNumberLabel.text = "좋아요 " + String(comment.likeNum ?? 0) + "개"
        // TODO: 대댓 개수
    }
}
