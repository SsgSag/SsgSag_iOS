//
//  ClubInfoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubInfoViewController: UIViewController {

    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var infoPhotoURLSet: [String] = ["1","2","3","4"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        labelGestureAdd()
    }
    
    func labelGestureAdd() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openURL))
        self.homePageLabel.addGestureRecognizer(tap)
    }

    @objc func openURL() {
        guard let urlString = self.homePageLabel.text else { return }
        let url = URL(string: urlString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}
