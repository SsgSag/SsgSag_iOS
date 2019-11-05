//
//  CommentCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol CommentDelegate: class {
    func touchUpCommentLikeButton(index: Int, like: Int)
    func presentAlertController(_ isMine: Bool, commentIndex: Int)
}

class CommentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: CommentDelegate?
    
    var comment: CommentList? {
        didSet {
            guard let comment = comment else {
                return
            }
            
            setupCellData(comment)
            
            if comment.isLike == 0 {
                likeButton.setImage(UIImage(named: "ic_likePassive"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "ic_like"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchUpLikeButton(_ sender: UIButton) {
        guard let index = comment?.commentIdx else {
            return
        }
        
        if sender.imageView?.image == UIImage(named: "ic_like") {
            // TODO: 좋아요수 줄일것
            sender.setImage(UIImage(named: "ic_likePassive"), for: .normal)
            delegate?.touchUpCommentLikeButton(index: index, like: 0)
        } else {
            // TODO: 좋아요수 증가시킬것
            sender.setImage(UIImage(named: "ic_like"), for: .normal)
            delegate?.touchUpCommentLikeButton(index: index, like: 1)
        }
    }
    
    @IBAction func touchUpEtcButton(_ sender: UIButton) {
        //TODO: alert 띄울것
        guard let commentIndex = comment?.commentIdx,
            let isMine = comment?.isMine == 1 ? true : false else {
            return
        }
        delegate?.presentAlertController(isMine, commentIndex: commentIndex)
    }
    
    private func setupCellData(_ comment: CommentList) {
        if let photoURL = comment.userProfileUrl {
            ImageNetworkManager.shared.getImageByCache(imageURL: photoURL) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let commentDateFormatter = DateFormatter.commentDateFormatter
        
        guard let commentRegDate = comment.commentRegDate,
            let date = dateFormatter.date(from: commentRegDate) else {
            return
        }
        
        nameLabel.text = comment.userNickname
        dateLabel.text = commentDateFormatter.string(from: date)
        commentLabel.text = comment.commentContent
        likeNumberLabel.text = "좋아요 " + String(comment.likeNum ?? 0) + "개"
    }
    
    override func prepareForReuse() {
        profileImageView.image = #imageLiteral(resourceName: "ic_userAnonymous")
        nameLabel.text = ""
        dateLabel.text = ""
        commentLabel.text = ""
        likeNumberLabel.text = ""
    }
}
