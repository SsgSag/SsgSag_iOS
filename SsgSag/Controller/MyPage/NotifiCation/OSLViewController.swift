//
//  OSLViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

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
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
