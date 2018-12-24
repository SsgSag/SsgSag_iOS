//
//  ViewController.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

//민지를 위한 주석 처리 ^_^
class CalenderVC: UIViewController {
    var theme = MyTheme.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "슥삭"
        self.navigationController?.navigationBar.isTranslucent=false
        //self.view.backgroundColor=Style.bgColor
        
        //왼쪽 오른쪽 스와이프
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        calenderView.gestureRecognizers = [swipeLeft, swipeRight]
        
        //전체 테마 색
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        //calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    //왼쪽 오른쪽 스와이프 할시
    @objc func rightSwipeAction() {
        calenderView.monthView.rightPanGestureAction()
    }
    @objc func leftSwipeAction() {
        calenderView.monthView.leftPanGestureAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
}

