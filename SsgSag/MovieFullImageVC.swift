//
//  MovieFullImageVC.swift
//  testingTinderSwipe
//
//  Created by admin on 22/12/2018.
//  Copyright © 2018 Nicky. All rights reserved.
//

import UIKit

class MovieFullImageVC: UIViewController {
    
    @IBOutlet var fullScreen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapScreen(_:)))
        
        fullScreen.isUserInteractionEnabled = true
        fullScreen.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK:- TapScreen
    @objc func tapScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
