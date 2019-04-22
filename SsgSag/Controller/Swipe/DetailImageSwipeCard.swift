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
    @IBOutlet var category: UILabel!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    var imageWidth: CGFloat = 0.0
    var imageHeight: CGFloat = 0.0
    
    //        if let posterName = posters.posterName,
    //            let outline = posters.outline,
    //            let target = posters.target,
    //            let benefit = posters.benefit,
    //            let keyword = posters.keyword,
    //            let posterCategory = posters.categoryIdx {
    //            //let period = posters.period {
    //
    //            detailTextSwipeCard.posterName.text = posterName
    //            detailTextSwipeCard.hashTag.text = keyword
    //            detailTextSwipeCard.outline.text = outline
    //            detailTextSwipeCard.target.text = target
    //            detailTextSwipeCard.benefit.text = benefit
    //            detailTextSwipeCard.posterCategory = posterCategory
    //            //detailTextSwipeCard.period.text = period
    //
    //            detailImageSwipeCardVC.detailImageVIew.load(url: posterURL)
    //            detailImageSwipeCardVC.name.text = posterName
    //            detailImageSwipeCardVC.category.text = keyword
    //            detailImageSwipeCardVC.posterCategory = posterCategory
    //        }
    
    var poster: Posters? {
        didSet {
            guard let poster = poster else { return }
            
            name.text = poster.posterName
            category.text = poster.keyword
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentView)
        view.addSubview(segmentSecondView)
        
        NSLayoutConstraint.activate([
            segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 3),
            segmentView.topAnchor.constraint(equalTo: view.topAnchor),
            
            segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            segmentSecondView.heightAnchor.constraint(equalToConstant: 3),
            segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor),
            ])
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
}

