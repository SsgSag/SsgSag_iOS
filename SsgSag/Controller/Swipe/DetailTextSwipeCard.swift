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
        segmentView.backgroundColor = .lightGray
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    var segmentSecondView: UIView = {
        let segmentView = UIView()
        segmentView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
}

struct PosterDetailResponse: Codable {
    let status: Int?
    let message: String?
    let data: posterDetail?
}

struct posterDetail: Codable {
    let posterIdx, categoryIdx: Int?
    let photoURL: String?
    let posterName, posterRegDate, posterStartDate, posterEndDate: String?
    let posterWebSite: String?
    let isSeek: Int?
    let outline, target, period, benefit: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let dday, adminAccept: Int?
    
    enum CodingKeys: String, CodingKey {
        case posterIdx, categoryIdx
        case photoURL = "photoUrl"
        case posterName, posterRegDate, posterStartDate, posterEndDate, posterWebSite, isSeek, outline, target, period, benefit, documentDate, contentIdx, hostIdx, posterDetail, posterInterest, dday, adminAccept
    }
}

