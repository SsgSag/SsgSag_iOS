//
//  CalendarDetailInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 20/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailPopUpVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 4.0
        titleLabel.layer.shadowOpacity = 4.0
        titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        titleLabel.layer.masksToBounds = false
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
