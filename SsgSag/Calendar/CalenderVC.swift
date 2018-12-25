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
    
    var calendarheightAncor : NSLayoutConstraint?
    var calendarBottomAncor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "슥삭"
        self.navigationController?.navigationBar.isTranslucent=false
        //self.view.backgroundColor=Style.bgColor
        
        //왼쪽 오른쪽 스와이프
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(downSwipeAction))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(upSwipeAction))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        swipeDown.direction = .down
        swipeUp.direction = .up
        
        calenderView.gestureRecognizers = [swipeLeft, swipeRight, swipeDown, swipeUp]
        
        //전체 테마 색
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        
        calendarheightAncor = calenderView.heightAnchor.constraint(equalToConstant: 500)
        calendarheightAncor?.isActive = true
        calendarBottomAncor = calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        calendarBottomAncor?.isActive = false
        
        view.addSubview(todoListButton)
        todoListButton.topAnchor.constraint(equalTo: calenderView.bottomAnchor, constant:10).isActive=true
        todoListButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        todoListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoListButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
//        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    @objc func upSwipeAction() {
        NotificationCenter.default.post(name: NSNotification.Name("upSwipe"), object: nil)
        calendarheightAncor?.isActive = true
        calendarBottomAncor?.isActive = false
    }
    @objc func downSwipeAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downSwipe"), object: nil)
        calendarheightAncor?.isActive = false
        calendarBottomAncor?.isActive = true
    }
    
    let todoListButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
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

