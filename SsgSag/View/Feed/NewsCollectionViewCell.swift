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
                let name = feedData.feedName,
                let host = feedData.feedHost,
                let viewNum = feedData.showNum,
                let date = feedData.feedRegDate else {
                return
            }
            
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: date)
            let dateFormatter = DateFormatter.feedDateFormatter
            let dateString = dateFormatter.string(from: endDate)
            
            newsTitleLabel?.text = name
            fromLabel?.text = host
            dateLabel?.text = dateString
            viewCountLabel?.text = "조회수 \(viewNum)"
            
            if feedData.isSave == 1 {
                bookmarkImageView.image = UIImage(named: "ic_bookmarkArticle")
            } else {
                bookmarkImageView.image = UIImage(named: "ic_bookmarkArticlePassive")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        bookmarkImageView?.image = nil
        newsImageView?.image = nil
        newsTitleLabel?.text = ""
        fromLabel?.text = ""
        dateLabel?.text = ""
        viewCountLabel?.text = ""
    }
}
