//
//  AllPosterListCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 20/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AllPosterListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var saveStatusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ddayButton: UIButton!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var calendarSaveCountButton: UIButton!
    @IBOutlet weak var hashTagLabel: UILabel!
    
    var posterData: PosterDataAfterSwpie? {
        didSet {
            guard let posterData = self.posterData else {
                return
            }
            
            setupCellData(posterData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupCellData(_ posterData: PosterDataAfterSwpie) {
        guard let title = posterData.posterName,
            let dday = posterData.dday,
            let viewCount = posterData.swipeNum,
            let calendarSaveCount = posterData.likeNum,
            let hashTag = posterData.keyword,
            let categoryIdx = posterData.categoryIdx else {
            return
        }
        
        if posterData.isSave == 0 {
            saveStatusButton.isHidden = true
        } else {
            saveStatusButton.isHidden = false
        }
        
        if let category = PosterCategory(rawValue: categoryIdx) {
            categoryButton.setTitle(category.categoryString(), for: .normal)
            categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
        }
        
        titleLabel.text = title
        ddayButton.setTitle("D-\(dday)", for: .normal)
        viewCountButton.setTitle("\(viewCount)", for: .normal)
        calendarSaveCountButton.setTitle("\(calendarSaveCount)", for: .normal)
        hashTagLabel.text = hashTag
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        saveStatusButton.isHidden = true
        ddayButton.setTitle("", for: .normal)
        viewCountButton.setTitle("", for: .normal)
        calendarSaveCountButton.setTitle("", for: .normal)
        titleLabel.text = ""
        hashTagLabel.text = ""
    }
}
