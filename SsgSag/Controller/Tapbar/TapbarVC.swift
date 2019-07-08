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
        static let mypageStoryBoard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        static let swipeStoryBoard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
        
        static let mypageViewController = mypageStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        static let swipeViewController = swipeStoryBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.swipe)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setService()
        
        isServerAvaliable()
        
        setTabBarViewController()
        
        setTabBarStyle()
        
        getPostersAndStore()
    }
    
    private func setupLayout() {
        tabBar.frame.size.height = 48
    }
    
    private func setService(_ tapbarServiceImp: TapbarService = TapbarServiceImp()) {
        self.tapbarServiceImp = tapbarServiceImp
    }
    
    // 서버가 유효한지 확인하는 메소드
    private func isServerAvaliable() {
        tapbarServiceImp?.requestIsInUpdateServer{ [weak self] dataResponse in
            guard let data = dataResponse.value?.data else { return }
            
            if data == 1 {
                self?.simplerAlert(title: "서버 업데이트 중입니다.")
            }
        }
    }
    
    private func setTabBarViewController() {
        let swipeViewController = CreateViewController.swipeViewController
        swipeViewController.tabBarItem = UITabBarItem(title: "",
                                                      image: UIImage(named: "icMain"),
                                                      selectedImage: UIImage(named: "icMainActive"))
        
        let mypageViewController = CreateViewController.mypageViewController
        mypageViewController.tabBarItem = UITabBarItem(title: "",
                                                       image: UIImage(named: "icUser"),
                                                       selectedImage: UIImage(named: "icUserActive"))
        
        let calendarViewController = CalenderVC()
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
        // 모든 Todolist를 가져오는듯
        tapbarServiceImp?.requestAllTodoList { (dataResponse) in
            
            guard let todoList = dataResponse.value else { return }
            
            StoreAndFetchPoster.shared.storePoster(posters: todoList)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        UIView.appearance().isExclusiveTouch = true
    }
}




