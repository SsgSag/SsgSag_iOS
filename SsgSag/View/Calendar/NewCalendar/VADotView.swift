//
//  VADotView.swift
//  VACalendar
//
//  Created by Anton Vodolazkyi on 25.02.18.
//  Copyright © 2018 Vodolazkyi. All rights reserved.
//

import UIKit

class VADotView: UIView {
    
    init(size: CGFloat, color: UIColor) {
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VALineView: UIView {
    
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_calendarFavorite")
        return imageView
    }()
    
    let posterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 1
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init(color: UIColor, text: String, isFavorite: Int) {
        
        let frame = CGRect(x: 0, y: 0, width: 20, height: 7)
        super.init(frame: frame)
        
        posterLabel.text = "\(text)"
        backgroundColor = color
        
        layer.cornerRadius = 2
        clipsToBounds = true
        
        addSubview(favoriteImageView)
        addSubview(posterLabel)
        
        favoriteImageView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 3).isActive = true
        favoriteImageView.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
        favoriteImageView.heightAnchor.constraint(
            equalToConstant: 7).isActive = true
        
        if isFavorite == 1 {
            favoriteImageView.widthAnchor.constraint(
                equalToConstant: 7).isActive = true
        } else {
            favoriteImageView.widthAnchor.constraint(
                equalToConstant: 0).isActive = true
        }
        
        posterLabel.leadingAnchor.constraint(
            equalTo: favoriteImageView.trailingAnchor,
            constant: 1).isActive = true
        posterLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        posterLabel.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
