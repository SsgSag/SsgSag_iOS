//
//  DetailPosterImageVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 28/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ZoomPosterImageVC: UIViewController, UIScrollViewDelegate {

    var poster: UIImage = #imageLiteral(resourceName: "1")
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        imageView.image = poster
    }
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //스크롤뷰가 줌해줄 뷰가 무엇인가유
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    


}
