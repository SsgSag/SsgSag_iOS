//
//  PosterHeaderCollectionReusableView.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol LargeImageDelegate: class {
    func presentLargeImage()
}

class PosterHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var posterTitleLabel: UILabel!
    
    @IBOutlet weak var periodLabel: UILabel!

    @IBOutlet weak var hashTagTextView: UITextView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: LargeImageDelegate?
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: nil)
    
    var detailData: DataClass? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapGesture.delegate = self
        posterImageView.addGestureRecognizer(tapGesture)
        
        hashTagTextView.textContainer.lineFragmentPadding = 0
        hashTagTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func configure() {
        guard let data = detailData,
            let categoryIdx = data.categoryIdx else { return }
        
        if let category = PosterCategory(rawValue: categoryIdx) {
            categoryButton.setTitle(category.categoryString(), for: .normal)
            categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
        }
        
        if data.favoriteNum != nil {
            let favoriteString = String(data.favoriteNum!)
            favoriteButton.setTitle(favoriteString, for: .normal)
        }
        
        if data.likeNum != nil {
            let likeString = String(data.likeNum!)
            likeButton.setTitle(likeString, for: .normal)
        }
        
        //        if data.partnerPhone == nil && detailData.partnerEmail == nil {
        //            contactInfoHeightConstraint.constant = 0
        //        }
        //
        //        if let partnerPhone = data.partnerPhone {
        //            partnerPhoneNumLabel.text = "전화번호: " + partnerPhone
        //        }
        //
        //        if let partnerEmail = data.partnerEmail {
        //            partnerEmailLabel.text = "이메일: " + partnerEmail
        //        }
        
        periodLabel.text
            = DateCaculate.getDifferenceBetweenStartAndEnd(startDate: data.posterStartDate,
                                                           endDate: data.posterEndDate)
        hashTagTextView.text = data.keyword
        
        posterTitleLabel.text = data.posterName
        //        outLineLabel.text = detailData.outline
        //        targetLabel.text = detailData.target
        //        benefitLabel.text = detailData.benefit
        //        seeMoreLabel.text = detailData.posterDetail
    }
}

extension PosterHeaderCollectionReusableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        delegate?.presentLargeImage()
        return true
    }
}
