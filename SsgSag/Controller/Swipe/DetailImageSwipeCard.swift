//
//  infoImageViewController.swift
//  SsgSag
//
//  Created by admin on 26/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailImageSwipeCardVC: UIViewController {
    
    @IBOutlet weak var detailImageVIew: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var day: UILabel!
    
    var imageWidth: CGFloat = 0.0
    
    var imageHeight: CGFloat = 0.0
    
    weak var delegate: movoToDetailPoster?
    
    private var segmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var segmentSecondView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var detailPoster: UIButton = {
        let button = UIButton()
        button.alpha = 0.7
        button.setImage(UIImage(named: "ic_closeUp"), for: .normal)
        button.addTarget(self, action: #selector(moveToZoomPosterVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var poster: Posters? {
        didSet {
            guard let poster = poster else { return }
            
            name.text = poster.posterName
            
            hashTag.text = poster.keyword
            
            posterCategory = poster.categoryIdx
            
            guard let posterEndDate = poster.posterEndDate else { return }
            
            let interval = DateCaculate.dayInterval(using: posterEndDate)
            
            day.text = "D-\(interval)"
            
            guard let posterURLString = poster.photoUrl else { return }
            
            guard let posterURL = URL(string: posterURLString) else { return }
            
            ImageNetworkManager.shared.getImageByCache(imageURL: posterURL) { [weak self] image, error in
                self?.detailImageVIew.image = image
            }
        }
    }
    
    var posterCategory: Int? {
        didSet {
            guard let posterCategoryIdx = posterCategory else { return }
    
            guard let category = PosterCategory(rawValue: posterCategoryIdx) else { return }
            
            self.categoryButton.setTitle(category.categoryString(), for: .normal)
            
            self.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            
            self.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
            
            self.hashTag.textColor = .lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        name.adjustsFontSizeToFitWidth = true
        hashTag.adjustsFontSizeToFitWidth = true
        
        view.addSubview(segmentView)
        view.addSubview(segmentSecondView)
        view.addSubview(detailPoster)
        
        NSLayoutConstraint.activate([
            segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5.5),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            segmentView.heightAnchor.constraint(equalToConstant: 5),
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5.5),
            segmentSecondView.heightAnchor.constraint(equalToConstant: 5),
            segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            detailPoster.trailingAnchor.constraint(equalTo: detailImageVIew.trailingAnchor, constant: -13.6),
            detailPoster.bottomAnchor.constraint(equalTo: detailImageVIew.bottomAnchor, constant: -15),
            detailPoster.heightAnchor.constraint(equalToConstant: 40),
            detailPoster.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        segmentView.layer.cornerRadius = 3
        segmentSecondView.layer.cornerRadius = 3
    }
    
    @objc private func moveToZoomPosterVC() {
        delegate?.pressButton()
    }
    
    deinit {
        print("DetailImageSwipeCard deinit")
    }
}

protocol movoToDetailPoster: class {
    func pressButton()
}
