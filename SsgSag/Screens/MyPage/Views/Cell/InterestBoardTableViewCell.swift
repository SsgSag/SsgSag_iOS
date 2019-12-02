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
            guard let interestInfo = self.interestInfo else { return }
            
            guard let interestName = interestInfo.interestName,
                let userIdx = interestInfo.userIdx,
                let colorHexString = interestInfo.interestUrl else { return }
            
            categoryButton.setTitle(interestName, for: .normal)
            categoryButton.backgroundColor = UIColor(hex: colorHexString)?.withAlphaComponent(0.08)
            categoryButton.setTitleColor(UIColor(hex: colorHexString), for: .normal)
            hashTag.text = interestInfo.interestDetail ?? ""
            
            if isNotSubscribe(userIdx) {
                changeAllColorToUnFollow()
            } else {
                changeAllColorToFollow()
            }
        }
    }
    
    private func changeAllColorToUnFollow() {
        selectFollow.setTitle("팔로우", for: .normal)
        selectFollow.backgroundColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        selectFollow.setTitleColor(.white, for: .normal)
        selectFollow.layer.borderWidth = 0
    }
    
    private func changeAllColorToFollow() {
        selectFollow.setTitle("팔로잉", for: .normal)
        selectFollow.backgroundColor = .white
        selectFollow.setTitleColor(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        selectFollow.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        selectFollow.layer.borderWidth = 1
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
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18))
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
                b = CGFloat(hexNumber & 0x0000ff) / 255.0
                
                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }
        return nil
    }
}
