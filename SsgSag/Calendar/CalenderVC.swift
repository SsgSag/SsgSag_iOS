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
        let todoSwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(todoUp))
        let todoSwipeDown = UITapGestureRecognizer(target: self, action: #selector(todoDown))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        calenderView.gestureRecognizers = [swipeLeft, swipeRight,todoSwipeUp]
        todoSwipeUp.direction = .up
        todoUpDownView.gestureRecognizers = [todoSwipeDown]
        
        //전체 테마 색
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        view.addSubview(todoUpDownView)
        todoUpDownView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoUpDownView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoUpDownView.topAnchor).isActive = true
    }
    
    @objc func todoUp(){
        print("TODO UP")
        calendarheightAncor?.isActive = true
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        todoStatus = -1
    }
    
    @objc func todoDown(){
        print("TODO DOWN")
        NotificationCenter.default.post(name: NSNotification.Name("changeToDown"), object: nil)
        
        calendarheightAncor?.isActive = false
        
        calendarheightAncor = calenderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0)
        calendarheightAncor?.isActive = true
        calendarheightAncor = calenderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        todoStatus = 1
    }
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

