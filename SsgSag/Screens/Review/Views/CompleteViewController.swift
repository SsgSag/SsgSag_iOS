//
//  CompleteViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    var subText = ""
    var titleText = ""
    var isPopup = false
    var service: ReviewServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        subLabel.text = subText
        returnButton.deviceSetSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isPopup {
            guard let popupVC = UIStoryboard(name: "ReviewEvent", bundle: nil).instantiateViewController(withIdentifier: "EventVC") as? EventViewController else {return}
            popupVC.service = service
            present(popupVC, animated: true)
        }
    }
    
    @IBAction func dismissClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
