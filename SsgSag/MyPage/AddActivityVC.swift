//
//  AddActivityVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class AddActivityVC: UIViewController {

    @IBOutlet weak var activityNavigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityNavigationBar.barStyle = .black
        

        
    }

    @IBAction func dismissModalAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
