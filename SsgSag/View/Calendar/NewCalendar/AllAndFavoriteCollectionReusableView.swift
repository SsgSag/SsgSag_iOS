//
//  AllAndFavoriteCollectionReusableView.swift
//  SsgSag
//
//  Created by 이혜주 on 12/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol MenuSelectedDelegate: class {
    func selectedMenu(index: Int)
}

class AllAndFavoriteCollectionReusableView: UICollectionReusableView {

    weak var delegate: MenuSelectedDelegate?
    
    @IBOutlet weak var allUnderBarView: UIView!
    
    @IBOutlet weak var favoriteUnderBarView: UIView!
    
    @IBOutlet weak var allButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // 전체 : -1 , 즐겨찾기 : -2
    @IBAction func touchUpAllButton(_ sender: UIButton) {
        let otherButton: UIButton = sender == allButton ? favoriteButton : allButton
        
        if sender == allButton {
            allUnderBarView.isHidden = false
            favoriteUnderBarView.isHidden = true
            delegate?.selectedMenu(index: -1)
        } else {
            allUnderBarView.isHidden = true
            favoriteUnderBarView.isHidden = false
            delegate?.selectedMenu(index: -2)
        }
        
        sender.isSelected = true
        otherButton.isSelected = false
        
        otherButton.setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), for: .normal)
        otherButton.titleLabel?.font = UIFont.systemFont(ofSize: 15,
                                                            weight: .regular)
        
        sender.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 15,
                                                    weight: .semibold)
    }
    
    func deselectedAllMenu() {
        allButton.isSelected = false
        favoriteButton.isSelected = false
        allUnderBarView.isHidden = true
        favoriteUnderBarView.isHidden = true
        
        allButton.setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), for: .normal)
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 15,
                                                       weight: .regular)
        
        favoriteButton.setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15,
                                                            weight: .regular)
    }
}
