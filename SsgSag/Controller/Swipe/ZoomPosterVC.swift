//
//  DetailPosterImageVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 28/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ZoomPosterVC: UIViewController, UIScrollViewDelegate {
    
    internal var poster: UIImage?
    
    var urlString: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        guard let posterURLString = self.urlString else {return}
        
        guard let posterURL = URL(string: posterURLString) else { return }
        
        ImageNetworkManager.shared.getImageByCache(imageURL: posterURL) { image, error in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func backToPresenting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
