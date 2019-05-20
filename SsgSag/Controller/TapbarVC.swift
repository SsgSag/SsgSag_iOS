//
//  TapbarVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class TapbarVC: UITabBarController {
    
    var tapbarServiceImp: TapbarService?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeStoryBoard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
        let mypageStoryBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        tapbarServiceImp = TapbarServiceImp()
        
        isServerAvaliable()
        
        let firstViewController = swipeStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.swipe)
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icMain"), selectedImage: UIImage(named: "icMainActive"))
        
        let secondViewController = mypageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icUser"), selectedImage: UIImage(named: "icUserActive"))
        
        let thirdViewController = CalenderVC()
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icCal"), selectedImage: UIImage(named: "icCalActive"))
        
        let tabBarList = [secondViewController, firstViewController, thirdViewController]
        
        self.viewControllers = tabBarList
        
        self.tabBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.barStyle = .black
        
        self.selectedIndex = 1
        
        getPostersAndStore()
    }
    
    private func isServerAvaliable() {
        tapbarServiceImp?.requestIsInUpdateServer{ (dataResponse) in
            guard let data = dataResponse.value?.data else {return}
            
            if data == 1 {
                self.simplerAlert(title: "서버 업데이트 중입니다.")
            }
        }
    }
    
    /// start only at first time
    private func getPostersAndStore() {
        
        guard let _ = UserDefaults.standard.object(forKey: "start") as? Bool else {
            
            let start = true
            
            UserDefaults.standard.setValue(start, forKey: "start")
            
            syncDataAtFirst()
            
            return
        }
    }
    
    private func syncDataAtFirst() {
        
        tapbarServiceImp?.requestAllTodoList { (dataResponse) in
            
            guard let todoList = dataResponse.value else { return }
        
            StoreAndFetchPoster.storePoster(posters: todoList)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.safeAreaInsets.top - 8
        let barHeight: CGFloat = 56
        tabFrame.size.height = barHeight
        self.tabBar.frame = tabFrame
        
        UIView.appearance().isExclusiveTouch = true
    }
}




