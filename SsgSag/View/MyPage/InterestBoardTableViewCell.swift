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
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var selectFollow: UIButton!
    
    var indexPath: IndexPath!
    
    var interestFollowDelegate: InterestFollowDelegate?
    
    var interestInfo: SubscribeInterests? {
        didSet {
            guard let interestInfo = self.interestInfo else {return}
            
            guard let interestName = interestInfo.interestName else {return}
            
            guard let userIdx = interestInfo.userIdx else {return}
        
            guard let interestType = InterestType(rawValue: interestName) else {return}
            
            categoryButton.setTitle(interestName, for: .normal)
            
            hashTag.text = interestType.hashTagString()
            
            if isNotSubscribe(userIdx) {
                changeAllColorToUnFollow()
            } else {
                changeAllColorToFollow()
            }
        }
    }
    
    private func changeAllColorToUnFollow() {
        selectFollow.setTitle("언팔로우", for: .normal)
        selectFollow.backgroundColor = .lightGray
        
        categoryButton.setTitleColor(.lightGray, for: .normal)
        categoryButton.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.08)
    }
    
    private func changeAllColorToFollow() {
        selectFollow.setTitle("팔로우", for: .normal)
        selectFollow.backgroundColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        categoryButton.setTitleColor(#colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1), for: .normal)
        categoryButton.backgroundColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 0.08)
        
    }
    
    
    
    private func isNotSubscribe(_ userIdx: Int) -> Bool {
        if userIdx == 0 {
            return true
        }
        
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 3
        contentView.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.937254902, alpha: 1).cgColor
        
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
