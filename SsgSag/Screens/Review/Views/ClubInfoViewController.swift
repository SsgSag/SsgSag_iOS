//
//  ClubInfoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubInfoViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    var infoPhotoURLSet: [String] = ["1","2","3","4"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self

    }
    
    
}
