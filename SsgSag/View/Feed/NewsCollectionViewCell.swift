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
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    var feedData: FeedData? {
        didSet {
            guard let feedData = feedData,
                let date = feedData.feedRegDate else {
                return
            }
            
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: date)
            let dateFormatter = DateFormatter.feedDateFormatter
            let dateString = dateFormatter.string(from: endDate)
            
            newsTitleLabel.text = feedData.feedName
            fromLabel.text = feedData.feedHost
            dateLabel.text = dateString
            viewCountLabel.text = "조회수 "
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
