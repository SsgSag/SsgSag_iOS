//
//  AppInfoViewController.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

let latestVersion = "2.0.0"

class AppInfoViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var outline: UILabel!
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        self.navigationItem.title = "앱 정보"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String else { return }
        
        versionLabel.text = version
        
        if latestVersion == version {
            outline.isHidden = false
        }
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

}
