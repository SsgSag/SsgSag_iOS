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
        segmentView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
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

