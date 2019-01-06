//
//  AddPassiveDateVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AddPassiveDateVC: UIViewController {
    @IBOutlet var startYearMonthDay: UILabel!
    @IBOutlet var startTime: UILabel!
    
    @IBOutlet var endYearMonthDay: UILabel!
    @IBOutlet var endTime: UILabel!
    
    @IBAction func startDateButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        let pickerVC = storyBoard.instantiateViewController(withIdentifier: "PopupVC")
        
        self.addChild(pickerVC)
        pickerVC.view.frame = self.view.frame
        self.view.addSubview(pickerVC.view)
        
        pickerVC.didMove(toParent: self)
    }
    
    @IBAction func endDateButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
    
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
