//
//  MyFilterCollectionReusableView.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class MyFilterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(header: MyFilterHeader) {
        titleLabel.text = header.title
        contentLabel.text = header.description
    }
    
}
