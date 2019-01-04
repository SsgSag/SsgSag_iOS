//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class myPageVC: UIViewController {
    
//    @IBOutlet weak var divisionLineView: UIView!
    
 
    override func viewDidLoad() {
       super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        var gradient = CAGradientLayer()
//
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.colors = [
//            UIColor.rgb(red: 65, green: 163, blue: 255),
//            UIColor.rgb(red: 155, green: 65, blue: 250)
//        ]
//        self.divisionLineView.layer.addSublayer(gradient)
        
    }
    


    func myButtonTapped(myButton: UIButton){
        if myButton.isSelected == true {
            myButton.isSelected = false
        }else {
            myButton.isSelected = true
        }
    }
    
}
