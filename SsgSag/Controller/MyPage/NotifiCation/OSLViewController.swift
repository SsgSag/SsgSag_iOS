//
//  OSLViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Lottie

class OSLViewController: UIViewController {

    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "OSL"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let animation = LOTAnimationView(name: "main_empty_hifive")
        
        view.addSubview(animation)
        view.sendSubviewToBack(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 350).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        animation.loopAnimation = true
        animation.play()
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
