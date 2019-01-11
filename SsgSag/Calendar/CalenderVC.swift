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
    
    var selectedStatus = 0
    
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
        bt.setImage(#imageLiteral(resourceName: "btnFloatingPlus"), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        //bt.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1.0)
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
    
    let separatorView: UIView = {
        let separ = UIView()
        separ.translatesAutoresizingMaskIntoConstraints = false
        return separ
    }()
    
    let todoListButton: UIButton = {
        let tb = UIButton()
        tb.setTitle("투두리스트", for: .normal)
        tb.setTitleColor(UIColor.black, for: .normal)
        tb.layer.cornerRadius = 12
        tb.backgroundColor = UIColor.white
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    var todoExampleDate:[(Date, Date, Int, Int, String, Int)] = []
    var todoSelectedDate:[(Date, Date, Int, Int, String, Int)] = []
    var posterTuple:[(Date, Date, Int, Int, String, Int)] = []//마지막을 카테고리 인덱스 넣자
    
    
    func isDuplicatePosterTuple(_ posterTuples:[(Date, Date, Int, Int, String, Int)], input: (Date, Date, Int, Int, String, Int)) -> Bool {
        for i in posterTuples {
            if i.4 == input.4 {
                return true
            }
        }
        return false
    }
    
    //여기서 중복 되는 것을 거르자.
    @objc func addUserDefaults() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //print("캘린더 tableview에도 추가하자")
        
        let defaults = UserDefaults.standard
        //guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        //guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo { //userDefaults에 있는 모든 poster 정보를 불러온다.
                    
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    let inputData:(Date, Date, Int, Int, String, Int) = (posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0)
                    
                    if isDuplicatePosterTuple(posterTuple, input: inputData) == false {
                        posterTuple.append(inputData)
                        //print("추가된 posterTuple \(poster)" )
                        //print(posterTuple.count)
                    }
                }
            }
        }
        
        let today = Date()
        
        for i in posterTuple {
            let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
            let posterTupleDay = Calendar.current.component(.day, from: i.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                if isDuplicatePosterTuple(todoExampleDate, input: i) == false {
                        todoExampleDate.append(i)
                }
            }
            //print("posterTuple \(i)")
        }
        
        todoTableView.reloadData()
        
    }
    
    //유저 디폴츠의 모든 내용 제거
    func removeDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "poster")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //유저 디폴츠 데이터 지우기
        //removeDefaults()
        
        Style.themeLight()
        
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        let todoSwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(todoUpBySwipe))
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
        todoTableView.backgroundColor = UIColor(displayP3Red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 1.0)
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(todoUpDownView)
        todoUpDownView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoUpDownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoUpDownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoUpDownView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        /* todoUpDownView에 포함되는 뷰 */
        todoUpDownView.addSubview(donwTodoView)
        donwTodoView.topAnchor.constraint(equalTo: todoUpDownView.topAnchor, constant: 10).isActive = true
        donwTodoView.centerXAnchor.constraint(equalTo: todoUpDownView.centerXAnchor).isActive = true
        donwTodoView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        donwTodoView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        todoUpDownView.addSubview(todoList)
        todoList.centerXAnchor.constraint(equalTo: todoUpDownView.centerXAnchor).isActive = true
        todoList.bottomAnchor.constraint(equalTo: todoUpDownView.bottomAnchor).isActive = true
        todoList.topAnchor.constraint(equalTo: donwTodoView.bottomAnchor, constant: 10).isActive = true
        todoList.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        todoUpDownView.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        /* */
        
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
        
        view.addSubview(todoListButton)
        todoListButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-34).isActive = true
        todoListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoListButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        todoListButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        todoListButton.isHidden = true
        todoListButton.addTarget(self, action: #selector(gotoTodoList), for: .touchUpInside)
        
        
        //var posterTuple:[(Date, Date, Int, Int, String, Int)] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaults = UserDefaults.standard
        //guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        //guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        //뷰디드로드, 포스터 튜플에 유저 디폴츠에 있는 값을 가져오자
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo { //userDefaults에 있는 모든 poster 정보를 불러온다.
                    
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    posterTuple.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                    //print("투두 테이블에 등록 하자: \(poster)" )
                   // print(posterTuple.count)
                }
            }
        }
        
        //긴날짜 순으로 정렬
        posterTuple.sort{$0.1 < $1.1}
        
        let today = Date()
        
        for i in posterTuple {
            let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
            let posterTupleDay = Calendar.current.component(.day, from: i.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                if isDuplicatePosterTuple(todoExampleDate, input: i) == false {
                        todoExampleDate.append(i)
                }
            }
            //print("posterTuple \(i)")
        }
        
        //캘린더 view에서 날짜가 선택 되었다. todoView가 올라간다.
        NotificationCenter.default.addObserver(self, selector: #selector(dayDidSelected(_:)), name: NSNotification.Name(rawValue: "todoUp"), object: nil)
        
    }
    
    //투두 리스트 테이블 표현
    //현재 선택된 cell의 색깔을 없애고
    @objc func gotoTodoList() {
        selectedStatus = 0
        todoListButton.isHidden = true
        
        todoExampleDate = []
        
        //테이블뷰의 데이터를 투두리스트로 바꾼다.
        let today = Date()
        for i in posterTuple {
            let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
            let posterTupleDay = Calendar.current.component(.day, from: i.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                if isDuplicatePosterTuple(todoExampleDate, input: i) == false {
                    todoExampleDate.append(i)
                }
                
            }
        }
        
        //현재 선택된 셀의 색깔을 바꾼다. //오늘일때는 제외
        NotificationCenter.default.post(name: NSNotification.Name("changeBackgroundColor"), object: nil)
        todoList.text = "투두리스트"
        
        todoTableView.reloadData()
        
       // print("투두 리스트로 갑시다")
    }
    
    //셀에서 가장 오른쪽에 있는 값들을 지우자.
    @objc func dayDidSelected(_ notification: Notification) {
        selectedStatus += 1
        todoUp(notification)
    }
    
    @objc func addPassiveDate() {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AddPassiveDateNV")
        present(nav, animated: true, completion: nil)
    }
    
    //스와이프를 통해 올라간 뷰 이거는 선택된게 없으니깐
    @objc func todoUpBySwipe(){
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
        
        //todoListBUtton.isHidden 아니면 보이는 거니깐 todotableview를 보여주자
        view.bringSubviewToFront(todoListButton)
        todoListButton.isHidden = false
        //todoTableView.
        
        view.bringSubviewToFront(addButton)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        
        //print(selectedStatus)
        //todoList
        if selectedStatus == 0 {
            todoExampleDate = []
            let today = Date()
            for i in posterTuple {
                let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
                let posterTupleDay = Calendar.current.component(.day, from: i.1)
                
                let todayMonth = Calendar.current.component(.month, from: today)
                let todayDay = Calendar.current.component(.day, from: today)
                
                if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                    todoExampleDate.append(i)
                }
            }
            self.todoListButton.isHidden = true
            self.todoTableView.reloadData()
        }
        
        self.view.layoutIfNeeded()
        //        UIView.animate(withDuration: 0.1) {
        //            self.view.layoutIfNeeded()
        //        }
    }
    
    //선택해서 올라간 뷰 ---> 투두리스트 버튼 을 띄우자 , 내려갈땐 지우자
    @objc func todoUp(_ notification: Notification){
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
        
        
        //투두리스트 버튼이 보이니깐 투두테이블뷰의
        view.bringSubviewToFront(todoListButton)
        todoListButton.isHidden = false
        //todoListButton
        
        //todoListButton.backgroundColor = .black
        
        view.bringSubviewToFront(addButton)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        //guard let currentCellDateTime = notification.userInfo?["currentCellDateTime"] as? Date else { return }
        
        //마지막으로 선택된 날짜에 따라 투두 테이블 표현
        if let currentCellDateTime = notification.userInfo?["currentCellDateTime"] as? Date {
            //print ("currentCellDateTime: \(currentCellDateTime)")
            todoExampleDate = []
            //지금 선택된 날짜에
            for i in posterTuple {
                if i.0 <= currentCellDateTime && i.1 >= currentCellDateTime {
                    todoExampleDate.append(i)
                }
                //print("posterTuple의 데이터 추적하자\(i.4)")
            }
            
            let currentCellMonth = Calendar.current.component(.month, from: currentCellDateTime)
           // let currentCellYear = Calendar.current.component(.year, from: currentCellDateTime)
            let currentCellDay = Calendar.current.component(.day, from: currentCellDateTime)
            
            todoList.text = "\(currentCellMonth)월 \(currentCellDay)일"
            
            //날짜를 누르면 todotableview의 셀의 값을 바꾸는 과정
            self.todoTableView.reloadData()
        }
        
        
        //올라갈때 (선택 되었을때) todotableview의 값을 바꾼다.
        todoStatus = -1
    }
    
    @objc func todoDown(){
        NotificationCenter.default.post(name: NSNotification.Name("changeToDown"), object: nil)
        
        for subview in view.subviews {
            if subview == todoTableView || subview == todoUpDownView{
                subview.removeFromSuperview()
            }
        }
        
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(addButton)
        todoListButton.isHidden = true
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = 1
    }
    @objc func rightSwipeAction() {
        //print("왼쪽으로")
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
        todoDown()
        calenderView.monthView.rightPanGestureAction()
    }
    
    @objc func leftSwipeAction() {
        //print("오른쪽으로")
        todoDown()
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
        let nav = storyBoard.instantiateViewController(withIdentifier: "detailPosterVCNV")
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            //print("Edit tapped")
        })
        
        editAction.backgroundColor = UIColor.blue
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            //rint("Delete tapped")
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [editAction, deleteAction]
    }
}

extension CalenderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoExampleDate.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "지우기"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! todoCell
        
        let todayDay = Calendar.current.component(.day, from: Date())
        let todoListDay = Calendar.current.component(.day, from: todoExampleDate[indexPath.row].1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if indexPath.row % 3 == 0 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
        }else if indexPath.row % 3 == 1{
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 7/255, green: 166/255, blue: 255/255, alpha: 1.0)
        }else if indexPath.row % 3 == 2 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 254/255, green: 109/255, blue: 109/255, alpha: 1.0)
        }
        
        //print(todoExampleDate[indexPath.row])
        
        if todoExampleDate[indexPath.row].5 == 0 {
            cell.categoryLabel.text = "공모전"
        }else if todoExampleDate[indexPath.row].5 == 1{
            cell.categoryLabel.text = "대외활동"
        }else if todoExampleDate[indexPath.row].5 == 2{
            cell.categoryLabel.text = "동아리"
        }else if todoExampleDate[indexPath.row].5 == 3{
            cell.categoryLabel.text = "교내공지"
        }else if todoExampleDate[indexPath.row].5 == 4{
            cell.categoryLabel.text = "채용"
        }else {
            cell.categoryLabel.text = "기타"
        }
        
        
        cell.contentLabel.text = "\(todoExampleDate[indexPath.row].4)"
        
        let startMonth = Calendar.current.component(.month, from: todoExampleDate[indexPath.row].0)
        let startDay = Calendar.current.component(.day, from: todoExampleDate[indexPath.row].0)
        
        let endMonth = Calendar.current.component(.month, from: todoExampleDate[indexPath.row].1)
        let endDay = Calendar.current.component(.day, from: todoExampleDate[indexPath.row].1)
        
        cell.dateLabel.text = "\(startMonth).\(startDay) ~ \(endMonth).\(endDay)"
        cell.leftedDay.text = "\(todoListDay-todayDay)"
        
        return cell
    }
}

//todo tableview의 셀
class todoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(displayP3Red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
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
        bV.layer.cornerRadius = 5
        bV.layer.masksToBounds = true
        bV.translatesAutoresizingMaskIntoConstraints = false
        return bV
    }()
    
    let leftLineView: UIView = {
        let leftView = UIView()
        //leftView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        //leftView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
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
        sv.backgroundColor = UIColor(displayP3Red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        return sv
    }()
    
    let leftedDay: UILabel = { //남은 날짜
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "3"
        return lb
    }()
    
    let leftedDayBottom: UILabel = {//남은 날짜 밑에 (일 남음 텍스트)
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "일 남음"
        return lb
    }()
    
    func setupCell(){
        self.selectionStyle = .none
        
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        borderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        borderView.backgroundColor = UIColor(displayP3Red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        
        borderView.addSubview(leftLineView)
        leftLineView.leftAnchor.constraint(equalTo: borderView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        leftLineView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        
        borderView.addSubview(categoryLabel)
        categoryLabel.text = "Label"
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
//        categoryLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
//        categoryLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        categoryLabel.font = UIFont(name: "system", size: 12)
        
        borderView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor ,constant: 5).isActive
            = true
        contentLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        contentLabel.font = UIFont(name: "system", size: 17)
        
        borderView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        contentLabel.font = UIFont(name: "system", size: 13)
        
        borderView.addSubview(separatorView)
        separatorView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -70).isActive = true
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
        borderView.addSubview(leftedDay)
        leftedDay.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -28).isActive = true
        leftedDay.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 15).isActive = true
        //leftedDay.widthAnchor.constraint(equalToConstant: 38).isActive = true
        //leftedDay.heightAnchor.constraint(equalToConstant: 41).isActive = true
        leftedDay.font = UIFont(name: leftedDay.font.fontName, size: 23)
        
        borderView.addSubview(leftedDayBottom)
        leftedDayBottom.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8).isActive = true
        leftedDayBottom.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -21).isActive = true
        leftedDayBottom.font = UIFont(name: leftedDay.font.fontName, size: 10)
        
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
