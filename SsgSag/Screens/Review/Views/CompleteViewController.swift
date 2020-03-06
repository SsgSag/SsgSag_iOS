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
    
    var subText: String?
    var titleText: String?
    var isPopup: Bool?
    var isEditMode: Bool?
    var clubIdx: Int?
    var service: ReviewServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        titleLabel.text = titleText
        subLabel.text = subText
        returnButton.deviceSetSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let isPopup = isPopup else {
            return
        }
        if isPopup {
            guard let popupVC = UIStoryboard(name: "ReviewEvent", bundle: nil).instantiateViewController(withIdentifier: "EventVC") as? EventViewController else {return}
            popupVC.service = service
            popupVC.clubIdx = clubIdx
            present(popupVC, animated: true)
        }
        
    }
    
    @IBAction func dismissClick(_ sender: Any) {
        guard let _ = isEditMode else {
            self.dismiss(animated: true)
            return
        }
        
        guard let secondVC = self.navigationController?.viewControllers[1] else {
            return
        }
        self.navigationController?.popToViewController(secondVC, animated: true)
        
    }
}
