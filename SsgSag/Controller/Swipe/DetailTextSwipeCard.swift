//
//  infoTextVC.swift
//  SsgSag
//
//  Created by admin on 26/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailTextSwipeCard: UIViewController {
    
    @IBOutlet var posterName: UILabel!
    
    @IBOutlet var hashTag: UILabel!
    
    @IBOutlet var outline: UILabel!
    
    @IBOutlet var target: UILabel!
    
    @IBOutlet var period: UILabel!
    
    @IBOutlet var benefit: UILabel!
    
    var poster: Poster? {
        didSet {
            
            guard let poster = poster else { return }
            
            posterName.text = poster.posterName
            
            hashTag.text = poster.keyword
            
            outline.text = poster.outline
            
            target.text = poster.target
            
            benefit.text = poster.benefit
            
            posterCategory = poster.categoryIdx
        }
    }
    
    var posterCategory: Int? {
        didSet {
            guard let posterCategoryIdx = posterCategory else { return }
            
            guard let category = PosterCategory(rawValue: posterCategoryIdx) else {return}
            
            segmentSecondView.backgroundColor = category.categoryColors()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentView)
        view.addSubview(segmentSecondView)
        
        NSLayoutConstraint.activate([
            segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -3),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            segmentView.heightAnchor.constraint(equalToConstant: 5),
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            
            segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 3),
            segmentSecondView.heightAnchor.constraint(equalToConstant: 5),
            segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            ])
        
        segmentView.layer.cornerRadius = 3
        segmentSecondView.layer.cornerRadius = 3
        
    }
    
    private var segmentView: UIView = {
        let segmentView = UIView()
        segmentView.backgroundColor = .lightGray
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    private var segmentSecondView: UIView = {
        let segmentView = UIView()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
}



