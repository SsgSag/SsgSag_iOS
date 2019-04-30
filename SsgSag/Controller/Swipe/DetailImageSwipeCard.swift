//
//  infoImageViewController.swift
//  SsgSag
//
//  Created by admin on 26/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailImageSwipeCardVC: UIViewController {
    
    @IBOutlet var detailImageVIew: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var hashTag: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var dayLefted: UILabel!
    
    var imageWidth: CGFloat = 0.0
    
    var imageHeight: CGFloat = 0.0
    
    var delegate: movoToDetailPoster!
    
    var poster: Posters? {
        didSet {
            guard let poster = poster else { return }
            
            name.text = poster.posterName
            hashTag.text = poster.keyword
            posterCategory = poster.categoryIdx
            
            guard let posterURLString = poster.photoUrl else { return }
            
            guard let posterURL = URL(string: posterURLString) else { return }
            
            detailImageVIew.load(url: posterURL)
        }
    }
    
    var posterCategory: Int? {
        didSet {
            guard let posterCategoryIdx = posterCategory else { return }
    
            guard let category = PosterCategory(rawValue: posterCategoryIdx) else {return}
            
            segmentView.backgroundColor = category.categoryColors()
            
            dayLefted.backgroundColor = category.categoryColors()
            
            self.category.text = category.categoryString()
            
            self.category.textColor = category.categoryColors()
            
            self.hashTag.textColor = category.categoryColors()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.adjustsFontSizeToFitWidth = true
        hashTag.adjustsFontSizeToFitWidth = true
        category.adjustsFontSizeToFitWidth = true
        
        
        dayLefted.layer.cornerRadius = 59 / 2
        dayLefted.layer.masksToBounds = true
        
        view.addSubview(segmentView)
        view.addSubview(segmentSecondView)
        view.addSubview(detailPoster)
        
        NSLayoutConstraint.activate([
            segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -3),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            segmentView.heightAnchor.constraint(equalToConstant: 5),
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            
            segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 3),
            segmentSecondView.heightAnchor.constraint(equalToConstant: 5),
            segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            
            detailPoster.trailingAnchor.constraint(equalTo: detailImageVIew.trailingAnchor, constant: -17),
            detailPoster.bottomAnchor.constraint(equalTo: detailImageVIew.bottomAnchor, constant: -17),
            detailPoster.heightAnchor.constraint(equalToConstant: 40),
            detailPoster.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        segmentView.layer.cornerRadius = 3
        segmentSecondView.layer.cornerRadius = 3
    }
    
    var segmentView: UIView = {
        let segmentView = UIView()
        //segmentView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    var segmentSecondView: UIView = {
        let segmentView = UIView()
        segmentView.backgroundColor = .lightGray
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    var detailPoster: UIButton = {
        let button = UIButton()
        button.alpha = 0.7
        button.setImage(UIImage(named: "icMainExpand"), for: .normal)
        button.addTarget(self, action: #selector(moveToZoomPosterVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func moveToZoomPosterVC() {
        
        delegate.pressButton()
    }
    
}

protocol movoToDetailPoster {
    func pressButton()
}
