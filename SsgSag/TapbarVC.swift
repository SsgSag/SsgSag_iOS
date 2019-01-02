//
//  TapbarVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class TapbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeStoryBoard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
        let firstViewController = swipeStoryBoard.instantiateViewController(withIdentifier: "Swipe")
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icMain"), selectedImage: UIImage(named: "icMainActive"))
        
        let mypageStoryBoard = UIStoryboard(name: "myPageStoryBoard", bundle: nil)
        let secondViewController = mypageStoryBoard.instantiateViewController(withIdentifier: "myPage")
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icUser"), selectedImage: UIImage(named: "icUserActive"))
        
        let thirdViewController = CalenderVC()
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icCal"), selectedImage: UIImage(named: "icCalActive"))
        
        let tabBarList = [secondViewController, firstViewController, thirdViewController]
        self.viewControllers = tabBarList
        
    
        self.view.superview?.addSubview(self.tabBar)
        self.tabBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.barStyle = .black
       // self.additionalSafeAreaInsets. = self.tabBar
        
        
        //self.tabBar.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
        
//        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        additionalSafeAreaInsets.top = 10
        
        var tabFrame:CGRect = self.tabBar.frame
//        tabFrame.origin.y = self.view.frame.origin.y + 10
        tabFrame.origin.y = self.view.safeAreaInsets.top + 10
        let barHeight: CGFloat = 44
        tabFrame.size.height = barHeight
    

        
        
        
//
//        self.view.safeAreaLayoutGuide.

//        self.tabBar.translatesAutoresizingMaskIntoConstraints = false
//        self.tabBar.topAnchor.constraint(equalTo: self.view.superview?.topAnchor).isActive = true
//        self.tabBar.leftAnchor.constraint(equalTo: self.view.superview?.leftAnchor).isActive = true
//        self.tabBar.rightAnchor.constraint(equalTo: self.view.superview.rightAnchor).isActive = true
//        self.tabBar.heightAnchor.constraint(equalTo: self.view.superview.heightAnchor).isActive = true
        
        
        
        self.tabBar.frame = tabFrame
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
