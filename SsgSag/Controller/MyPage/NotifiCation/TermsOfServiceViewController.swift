//
//  TermsOfServiceViewController.swift
//  SsgSag
//
//  Created by admin on 21/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "개인정보 보호정책"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

}
