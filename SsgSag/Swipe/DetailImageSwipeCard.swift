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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
//extension UIImage {
//    // Crops an input image (self) to a specified rect
//    func cropToRect(rect: CGRect!) -> UIImage? {
//        // Correct rect size based on the device screen scale
//        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale)
//        // New CGImage reference based on the input image (self) and the specified rect
//        let imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect)
//
//        let Ref  CGIMage
//
//        // Gets an UIImage from the CGImage
//        let result = UIImage(CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
//        // Returns the final image, or NULL on error
//        return result;
//    }
//}
