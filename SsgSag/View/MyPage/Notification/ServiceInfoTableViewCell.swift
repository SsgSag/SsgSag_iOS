//
//  ServiceInfoTableViewCell.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ServiceInfoTableViewCell: UITableViewCell {
    
    internal var cellInfo: String? {
        didSet {
            guard let cellInfo = self.cellInfo else {return}
            
            title.text = cellInfo
        }
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showDetail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "icArrowNextMypage")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setContentView()
    }
    
    private func setContentView() {
        addSubview(title)
        addSubview(showDetail)
        
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        
        showDetail.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        showDetail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
