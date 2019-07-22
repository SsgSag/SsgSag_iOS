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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    private let newPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "alertNewPost")
        imageView.isHidden = true
        return imageView
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
        addSubview(newPostImageView)
        
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26).isActive = true
        
        newPostImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newPostImageView.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5).isActive = true
        newPostImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        newPostImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        showDetail.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        showDetail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNewPostImage() {
        newPostImageView.isHidden = false
    }
}
