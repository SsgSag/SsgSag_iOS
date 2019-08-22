//
//  NoTodoTableViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 20/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol ChangeTabbarItemDelegate: class {
    func moveToSwipe()
}

class NoTodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goToSwipeVCButton: UIButton!
    
    weak var delegate: ChangeTabbarItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var attributedString = NSMutableAttributedString(string: "")
        let buttonTitleStr = NSMutableAttributedString(string: "슥삭하러가기 >",
                                                       attributes: [NSAttributedString.Key.underlineStyle : 1])
        attributedString.append(buttonTitleStr)
        goToSwipeVCButton.setAttributedTitle(attributedString, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func goToSwipeVC(_ sender: UIButton) {
        delegate?.moveToSwipe()
    }
}
