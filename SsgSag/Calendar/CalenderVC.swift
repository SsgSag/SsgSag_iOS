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
    var calendarBottomAnchor : NSLayoutConstraint?
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
        todoView.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
        todoView.translatesAutoresizingMaskIntoConstraints = false
        return todoView
    }()
    
    let todoTableView: UITableView = {
        let todo = UITableView()
        todo.translatesAutoresizingMaskIntoConstraints = false
        return todo
    }()
    
    let addButton : UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1.0)
        return bt
    }()
    
    let donwTodoView: UIImageView = {
        let downView = UIImageView()
        downView.translatesAutoresizingMaskIntoConstraints = false
        downView.image = UIImage(named: "icTodoDown")
        return downView
    }()
    
    let todoList: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.text = "투두리스트"
        
        return label
    }()
    
    let todoExampleDate = ["1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
    
        let todoSwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(todoUp))
        let todoSwipeDown = UITapGestureRecognizer(target: self, action: #selector(todoDown))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        calenderView.gestureRecognizers = [swipeLeft, swipeRight,todoSwipeUp]
        todoSwipeUp.direction = .up
        
        todoUpDownView.gestureRecognizers = [todoSwipeDown]
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(todoUpDownView)
        todoUpDownView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoUpDownView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
//        view.addSubview(todoList)
//        todoList.centerXAnchor.constraint(equalTo: todoUpDownView.centerXAnchor).isActive = true
//        todoList.bottomAnchor.constraint(equalTo: todoUpDownView.bottomAnchor).isActive = true
//        todoList.heightAnchor.constraint(equalToConstant: 21).isActive = true
//
//        view.addSubview(donwTodoView)
//        donwTodoView.bottomAnchor.constraint(equalTo: todoList.topAnchor).isActive = true
//        donwTodoView.centerXAnchor.constraint(equalTo: todoUpDownView.centerXAnchor).isActive = true
//        donwTodoView.heightAnchor.constraint(equalToConstant: 9).isActive = true
//        donwTodoView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoUpDownView.topAnchor).isActive = true
        
        
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        addButton.layer.cornerRadius = 54 / 2
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addPassiveDate), for: .touchUpInside)

    }
    
    @objc func addPassiveDate() {
        print("1.출력안되나")
        
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AddPassiveDateNV")
        present(nav, animated: true, completion: nil)
    }
    
    @objc func todoUp(){
        print("투두 리스트 위로 올라간드아~")
        calendarheightAncor?.isActive = false
        
        for subview in view.subviews {
            if subview == calenderView{
                subview.removeFromSuperview()
            }
        }
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(todoUpDownView)
        todoUpDownView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoUpDownView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        view.addSubview(calenderView)
        //calenderView.bottomAnchor.constraint(equalTo: todoUpDownView.topAnchor).isActive = true
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoUpDownView.topAnchor).isActive = true
//        calendarBottomAnchor = calenderView.bottomAnchor.constraint(equalTo: todoUpDownView.topAnchor)
//        calendarBottomAncor?.isActive = true
        view.bringSubviewToFront(addButton)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = -1
    }
    
    @objc func todoDown(){
        print("투두 리스트 밑으로 내려간드아~")
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToDown"), object: nil)
        
        calendarheightAncor?.isActive = false
        calendarheightAncor = calenderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0)
        calendarheightAncor?.isActive = false
        calendarheightAncor = calenderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        
        for subview in view.subviews {
            if subview == todoTableView || subview == todoUpDownView{
                subview.removeFromSuperview()
            }
        }
        
//        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
//
//        todoUpDownView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
//        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        todoUpDownView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //calenderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(addButton)
        
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


extension CalenderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        
        let nav = storyBoard.instantiateViewController(withIdentifier: "CalendarDetailNV")
        present(nav, animated: true, completion: nil)
    }
}

extension CalenderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoExampleDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! todoCell
        
        return cell
    }
    
}

class todoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(displayP3Red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
        setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let borderView: UIView = {
        let bV = UIView()
        bV.layer.cornerRadius = 15
        bV.layer.masksToBounds = true
        bV.backgroundColor = .lightGray
        bV.translatesAutoresizingMaskIntoConstraints = false
        return bV
    }()
    
    let leftLineView: UIView = {
        let leftView = UIView()
        //leftView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
        return leftView
    }()
    
    let categoryLabel:UILabel = { //공모전
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    let contentLabel:UILabel = { //전국 창업연합 동아리
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let dateLabel: UILabel = { //날짜
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let separatorView: UIView = {//세로선
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .red
        return sv
    }()
    
    func setupCell(){
        self.selectionStyle = .none
        
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        borderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        addSubview(leftLineView)
        leftLineView.leftAnchor.constraint(equalTo: borderView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        leftLineView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.text = "Label"
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: leftLineView.rightAnchor, constant: 5).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        addSubview(separatorView)
        separatorView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -70).isActive = true
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
        
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
