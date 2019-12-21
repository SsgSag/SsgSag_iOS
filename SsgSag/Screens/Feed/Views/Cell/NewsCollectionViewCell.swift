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
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    var callback: ((Int, Int)->())?
    var indexPath: IndexPath?
    
    var feedData: FeedData? {
        didSet {
            setupFeedData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchUpBookmarkButton(_ sender: UIButton) {
        guard let feedIdx = feedData?.feedIdx else {
            return
        }
        
        let status = bookmarkButton.imageView?.image == UIImage(named: "ic_bookmarkArticle") ? 1 : 0
        
        callback?(feedIdx, status)
    }
    
    private func setupFeedData() {
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
            bookmarkButton.setImage(UIImage(named: "ic_bookmarkArticle"),
                                    for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "ic_bookmarkArticlePassive"),
                                    for: .normal)
        }
    }
    
    override func prepareForReuse() {
        bookmarkButton.setImage(nil, for: .normal)
        newsImageView?.image = UIImage(named: "ic_imgDefault")
        newsTitleLabel?.text = ""
        fromLabel?.text = ""
        dateLabel?.text = ""
        viewCountLabel?.text = ""
    }
}
