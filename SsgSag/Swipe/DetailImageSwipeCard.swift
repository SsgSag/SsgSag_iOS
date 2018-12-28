//
//  infoImageViewController.swift
//  SsgSag
//
//  Created by admin on 26/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailImageSwipeCardVC: UIViewController {
    
    var pageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        pageNumber = 1
//                let backGroundImageView = UIImageView(frame:bounds)
                guard let imageURL = URL(string: "https://randomuser.me/api/portraits/men/82.jpg") else {return}
        //        backGroundImageView.load(url: imageURL)
//                backGroundImageView.contentMode = .scaleAspectFill
//                backGroundImageView.clipsToBounds = true;
//                addSubview(backGroundImageView)
        
        //이미지 추가
        //        backGroundImageView.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        //        backGroundImageView.image = UIImage(data: <#T##Data#>)
    }
}
