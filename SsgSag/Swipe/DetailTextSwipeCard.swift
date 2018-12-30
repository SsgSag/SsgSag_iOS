//
//  infoTextVC.swift
//  SsgSag
//
//  Created by admin on 26/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailTextSwipeCard: UIViewController {

    var pageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //pageNumber = -1
        // Do any additional setup after loading the view.
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(actionPan))
        self.view.addGestureRecognizer(panGesture)
        
    }
    
    @objc func actionPan() {
        print("actionPan")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
