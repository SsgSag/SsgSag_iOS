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
        
        //self.tabBarController.selectedIndex = 2
        self.selectedIndex = 1
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.safeAreaInsets.top + 10
        let barHeight: CGFloat = 44
        tabFrame.size.height = barHeight
        self.tabBar.frame = tabFrame
    }
}
