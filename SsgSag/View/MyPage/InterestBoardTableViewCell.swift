//
//  InterestBoardTableViewCell.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class InterestBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullView: UIView!
    
    @IBOutlet weak var categoryColor: UIView!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var selectFollow: GradientButton!
    
    @IBOutlet weak var followLabel: UILabel!
    
    var indexPath: IndexPath!
    
    var interestFollowDelegate: InterestFollowDelegate?
    
    var interestInfo: SubscribeInterests? {
        didSet {
            
            guard let interestInfo = self.interestInfo else {return}
            
            guard let interestName = interestInfo.interestName else {return}
            
            guard let userIdx = interestInfo.userIdx else {return}
        
            guard let interestType = InterestType(rawValue: interestName) else {return}
            
            category.text = interestName
            
            hashTag.text = interestType.hashTagString()
            
            if isNotSubscribe(userIdx) {
                changeAllColorToUnFollow()
            } else {
                changeAllColorToFollow()
            }
        }
    }
    
    private func changeAllColorToUnFollow() {
        categoryColor.backgroundColor = .lightGray
        followLabel.text = "언팔로우"
        
        category.textColor = .lightGray
        hashTag.textColor = .lightGray
        
        selectFollow.topColor = .lightGray
        selectFollow.bottomColor = .lightGray
    }
    
    private func changeAllColorToFollow() {
        categoryColor.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.462745098, blue: 0.8666666667, alpha: 1)
        followLabel.text = "팔로우"
        
        category.textColor = .black
        hashTag.textColor = .black
        
        selectFollow.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        selectFollow.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
    }
    
    
    
    private func isNotSubscribe(_ userIdx: Int) -> Bool {
        if userIdx == 0 {
            return true
        }
        
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryColor.layer.cornerRadius = categoryColor.bounds.width / 2
        categoryColor.layer.masksToBounds = true
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 3
        contentView.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.937254902, alpha: 1).cgColor
        
        selectFollow.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        selectFollow.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }

    @IBAction func followOrUnFollow(_ sender: Any) {
        
        guard let interestInfo = self.interestInfo else {return}
        
        interestFollowDelegate?.interestFollowButton(using: interestInfo, indexPath: indexPath)
    }
}

protocol InterestFollowDelegate {
    func interestFollowButton(using interest: SubscribeInterests, indexPath: IndexPath)
}

extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
