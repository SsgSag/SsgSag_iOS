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
class CalenderVC: UIViewController{
    
    var todoStatus = 1
    
    var theme = MyTheme.dark
    
    var calendarheightAncor : NSLayoutConstraint?
    var calendarTopAncor: NSLayoutConstraint?
    var todoUpDownViewTopAncor: NSLayoutConstraint?
    
    var calendarBottomAncor : NSLayoutConstraint?
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let todoUpDownView: UIView = {
        let todoView = UIView()
        todoView.backgroundColor = .yellow
        todoView.translatesAutoresizingMaskIntoConstraints = false
        return todoView
    }()
    
    let todoTableView: UITableView = {
        let todo = UITableView()
        todo.translatesAutoresizingMaskIntoConstraints = false
        return todo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "슥삭"
        self.navigationController?.navigationBar.isTranslucent=false
        
        //Calendar Swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        calenderView.gestureRecognizers = [swipeLeft, swipeRight]//, swipeDown, swipeUp]
        
        //TODO Swipe
        let todoSwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(todoUp))
        let todoSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(todoDown))
        
        todoSwipeUp.direction = .up
        todoSwipeDown.direction = .down
        todoUpDownView.gestureRecognizers = [todoSwipeUp, todoSwipeDown]
        
        
        //전체 테마 색
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        view.addSubview(calenderView)
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        //calenderView.systemLayoutSizeFitting(<#T##targetSize: CGSize##CGSize#>)
        
        calendarTopAncor = calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        calendarTopAncor?.isActive = true
        calendarheightAncor = calenderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        calendarheightAncor?.isActive = true
        calendarBottomAncor = calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35)
        calendarBottomAncor?.isActive = false
        
        view.addSubview(todoUpDownView)
        todoUpDownViewTopAncor = todoUpDownView.topAnchor.constraint(equalTo: calenderView.bottomAnchor)
        todoUpDownViewTopAncor?.isActive = true
        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoUpDownView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(todoTableView)
        todoTableView.topAnchor.constraint(equalTo: todoUpDownView.bottomAnchor).isActive=true
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func todoUp(){
        print("TODO UP")
        calendarTopAncor?.isActive = true
        calendarheightAncor?.isActive = true
        todoUpDownViewTopAncor?.isActive = true
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = -1
    }
    
    @objc func todoDown(){
        print("TODO DOWN")
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToDown"), object: nil)
        
        todoUpDownViewTopAncor?.isActive = true
        calendarTopAncor?.isActive = true
        calendarheightAncor?.isActive = false
        calendarBottomAncor?.isActive = true
        
        //todoUpDownViewTopAncor = todoUpDownView.topAnchor.constraint(equalTo: calendarBottomAncor)
        //todoUpDownViewTopAncor?.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = 1
    }
    
    //왼쪽 오른쪽 스와이프 할시
    @objc func rightSwipeAction() {
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
        calenderView.monthView.rightPanGestureAction()
    }
    
    @objc func leftSwipeAction() {
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
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
    
    
}

