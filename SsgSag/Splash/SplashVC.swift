//
//  SplashVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 4..
//  Copyright © 2019년 wndzlf. All rights reserved.
//
import UIKit
import Lottie

class SplashVC: UIViewController {
    
    @IBOutlet weak var splashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splashAnimation = LOTAnimationView(name: "splash")
        splashView.addSubview(splashAnimation)
        
        splashAnimation.translatesAutoresizingMaskIntoConstraints = false
        splashAnimation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        splashAnimation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        splashAnimation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashAnimation.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        splashAnimation.play()
    }
}

