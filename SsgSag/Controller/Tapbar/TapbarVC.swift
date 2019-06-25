//
//  TapbarVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class TapbarVC: UITabBarController {
    
    private var tapbarServiceImp: TapbarService?
    
    struct CreateViewController {
        
        static let swipeStoryBoard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
        
        static let mypageStoryBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        static let newCalendarStoryboard = UIStoryboard(name: StoryBoardName.newCalendar, bundle: nil)
        
        static let swipeViewController = swipeStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.swipe)
        
        static let mypageViewController = mypageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        static let newCalendarViewController = newCalendarStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.newCalendarViewController) as! NewCalendarVC
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setService()
        
        isServerAvaliable()
        
        setTabBarViewControllers()
        
        setTabBarStyle()
        
        getPostersAndStore()
        
        UIView.appearance().isExclusiveTouch = true
    }
    
    func setService(_ tapbarServiceImp: TapbarService = TapbarServiceImp()) {
        self.tapbarServiceImp = tapbarServiceImp
    }
    
    private func isServerAvaliable() {
        tapbarServiceImp?.requestIsInUpdateServer{ [weak self] dataResponse in
            guard let data = dataResponse.value?.data else {return}
            
            if data == 1 {
                self?.simplerAlert(title: "서버 업데이트 중입니다.")
            }
        }
    }
    
    private func setTabBarViewControllers() {
        let swipeViewController = CreateViewController.swipeViewController
        swipeViewController.tabBarItem = UITabBarItem(title: "",
                                                      image: UIImage(named: "icMain"),
                                                      selectedImage: UIImage(named: "icMainActive"))
        
        let mypageViewController = CreateViewController.mypageViewController
        mypageViewController.tabBarItem = UITabBarItem(title: "",
                                                       image: UIImage(named: "icUser"),
                                                       selectedImage: UIImage(named: "icUserActive"))
        
        let calendarViewController = CreateViewController.newCalendarViewController
        StoreAndFetchPoster.shared.delegate = calendarViewController
        calendarViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(named: "icCal"),
                                                         selectedImage: UIImage(named: "icCalActive"))
        
        let tabBarList = [mypageViewController, swipeViewController, calendarViewController]
        
        self.viewControllers = tabBarList
    }
    
    private func setTabBarStyle() {
        self.tabBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.barStyle = .black
        
        self.selectedIndex = 1
    }
    
    /// start only at first time
    private func getPostersAndStore() {
        
        guard let _ = UserDefaults.standard.object(forKey: UserDefaultsName.syncWithLocalData) as? Bool else {
            
            let start = true
            
            UserDefaults.standard.setValue(start, forKey: UserDefaultsName.syncWithLocalData)
            
            syncDataAtFirst()
            
            return
        }
    }
    
    private func syncDataAtFirst() {
        
        tapbarServiceImp?.requestAllTodoList { (dataResponse) in
            
            guard let todoList = dataResponse.value else { return }
            
            StoreAndFetchPoster.shared.storePoster(posters: todoList)
        }
    }
    
}




