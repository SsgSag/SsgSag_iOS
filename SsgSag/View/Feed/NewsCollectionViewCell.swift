//
//  NewsCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 11/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    var feedData: FeedData? {
        didSet {
            guard let feedData = feedData else {
                return
            }
            
            newsTitleLabel.text = feedData.feedName
            fromLabel.text = feedData.feedHost
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        newsImageView.image = nil
        newsTitleLabel.text = ""
        fromLabel.text = ""
    }
}
