
import UIKit

enum MyTheme {
    case light
    case dark
}

class CalenderVC: UIViewController{
    private var todoStatus = 1
    private var selectedStatus = 0
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let todoSeparatorBar: UIView = {
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
    
    /* 일정 수동 추가 버튼
    let passiveScheduleAddButton : UIButton = {
        let bt = UIButton()
        bt.setImage(#imageLiteral(resourceName: "btnFloatingPlus"), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        //bt.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1.0)
        return bt
    }()
     */
    
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
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    
    let separatorLine: UIView = {
        let separ = UIView()
        separ.translatesAutoresizingMaskIntoConstraints = false
        return separ
    }()
    
    let todoListButton: UIButton = {
        let tb = UIButton()
        tb.setImage(UIImage(named: "icTodolistBtn"), for: .normal)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    private var todoData:[(Date, Date, Int, Int, String, Int)] = []
    
    var posterTuples:[(Date, Date, Int, Int, String, Int)] = []
    
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
        
        let posterTupleFromCalendarView = calenderView.posterTuples
        
        let today = Date()
        
        for posterTuple in posterTupleFromCalendarView {
            let posterTupleMonth = Calendar.current.component(.month, from: posterTuple.1)
            let posterTupleDay = Calendar.current.component(.day, from: posterTuple.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posterTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                if isDuplicatePosterTuple(todoData, input: posterTuple) == false {
                        todoData.append(posterTuple)
                }
            }
        }
        
        todoTableView.reloadData()
    }
    
    func setupContentView() {
        view.addSubview(todoTableView)
        view.addSubview(todoSeparatorBar)
        todoSeparatorBar.addSubview(donwTodoView)
        todoSeparatorBar.addSubview(todoList)
        todoSeparatorBar.addSubview(separatorLine)
        view.addSubview(calenderView)
        view.addSubview(todoListButton)
        
        NSLayoutConstraint.activate([
            todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor),
            todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            todoSeparatorBar.heightAnchor.constraint(equalToConstant: 54),
            
            donwTodoView.topAnchor.constraint(equalTo: todoSeparatorBar.topAnchor, constant: 10),
            donwTodoView.centerXAnchor.constraint(equalTo: todoSeparatorBar.centerXAnchor),
            donwTodoView.heightAnchor.constraint(equalToConstant: 9),
            donwTodoView.widthAnchor.constraint(equalToConstant: 44),
            
            todoList.centerXAnchor.constraint(equalTo: todoSeparatorBar.centerXAnchor),
            todoList.bottomAnchor.constraint(equalTo: todoSeparatorBar.bottomAnchor),
            todoList.topAnchor.constraint(equalTo: donwTodoView.bottomAnchor, constant: 10),
            todoList.heightAnchor.constraint(equalToConstant: 21),
            
            separatorLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: view.rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
        
            calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calenderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calenderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor),
            
            todoListButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-34),
            todoListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todoListButton.widthAnchor.constraint(equalToConstant: 135),
            todoListButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        todoTableView.backgroundColor = UIColor(displayP3Red: 251 / 255, green: 251 / 255, blue: 251 / 255, alpha: 1.0)
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        todoTableView.separatorStyle = .none
        todoTableView.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        separatorLine.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        todoList.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        
        todoListButton.isHidden = true
        todoListButton.addTarget(self, action: #selector(changeTodoTable), for: .touchUpInside)
        
        /*
         view.addSubview(passiveScheduleAddButton)
         view.bringSubviewToFront(passiveScheduleAddButton)
         passiveScheduleAddButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
         passiveScheduleAddButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
         passiveScheduleAddButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
         passiveScheduleAddButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
         passiveScheduleAddButton.layer.cornerRadius = 54 / 2
         passiveScheduleAddButton.layer.masksToBounds = true
         passiveScheduleAddButton.addTarget(self, action: #selector(addPassiveDate), for: .touchUpInside)
         */
    }
    
    func setupGesture() {
        let todoTableShow = UISwipeGestureRecognizer(target: self, action: #selector(todoTableSwipeUp))
        let todoTableHide = UITapGestureRecognizer(target: self, action: #selector(todoTableTapped))
        
        let movePreviousMonth = UISwipeGestureRecognizer(target: self, action: #selector(movePreviousMonthBySwipe))
        let moveNextMonth = UISwipeGestureRecognizer(target: self, action: #selector(moveNextMonthBySwipe))
        
        calenderView.gestureRecognizers = [movePreviousMonth, moveNextMonth, todoTableShow]
        
        movePreviousMonth.direction = .left
        moveNextMonth.direction = .right
        todoTableShow.direction = .up
        
        todoSeparatorBar.gestureRecognizers = [todoTableHide]
    }
    
    private func addtoTODOTable() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaults = UserDefaults.standard
        let today = Date()
        for i in posterTuples {
            let posterTupleMonth = Calendar.current.component(.month, from: i.1)
            let posterTupleDay = Calendar.current.component(.day, from: i.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posterTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0 {
                if isDuplicatePosterTuple(todoData, input: i) == false {
                    todoData.append(i)
                }
            }
        }
    }
    
    private func bringUserDefaultsAndSetPosetTupels(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaults = UserDefaults.standard
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    if isDuplicatePosterTuple(posterTuples, input: ((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))) == false {
                        posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                        
                        print("겹치지 않고 들어감 \(posterTuples.last)")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Style.bgColor
    
        setupContentView()
        setupGesture()
        
        //userDefaults 더하는 것에 요청함
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        //todoTable의 변화를 받음
        NotificationCenter.default.addObserver(self, selector: #selector(dayDidSelected(_:)), name: NSNotification.Name(rawValue: "todoUp"), object: nil)
        
        bringUserDefaultsAndSetPosetTupels()
        posterTuples.sort{$0.1 < $1.1}
        addtoTODOTable()
    }
    
    fileprivate func getDateAfterToday(_ today: Date) {
        for i in posterTuples {
            let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
            let posterTupleDay = Calendar.current.component(.day, from: i.1)
            
            let todayMonth = Calendar.current.component(.month, from: today)
            let todayDay = Calendar.current.component(.day, from: today)
            
            if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                if isDuplicatePosterTuple(todoData, input: i) == false {
                    todoData.append(i)
                }
            }
        }
    }
    
    @objc func changeTodoTable() {
        selectedStatus = 0
        todoListButton.isHidden = true
        todoData = []
        let today = Date()
        getDateAfterToday(today)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeBackgroundColor"), object: nil)
        
        todoList.text = "투두리스트"
        todoTableView.reloadData()
    }
    
    //날짜 선택시 실행
    @objc func dayDidSelected(_ notification: Notification) {
        selectedStatus += 1
        NotificationCenter.default.post(name: NSNotification.Name("rightItemHidden"), object: nil)
        
        todoUp(notification)
    }
    
    @objc func addPassiveDate() {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AddPassiveDateNV")
        present(nav, animated: true, completion: nil)
    }
    
    @objc func todoTableSwipeUp(){
        for subview in view.subviews {
            if subview == calenderView{
                subview.removeFromSuperview()
            }
        }
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(todoSeparatorBar)
        todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoSeparatorBar.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor).isActive = true
        
        view.bringSubviewToFront(todoListButton)
        todoListButton.isHidden = false
        
//        view.bringSubviewToFront(passiveScheduleAddButton)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        if selectedStatus == 0 {
            todoData = []
            let today = Date()
            for i in posterTuples {
                let posteurTupleMonth = Calendar.current.component(.month, from: i.1)
                let posterTupleDay = Calendar.current.component(.day, from: i.1)
                
                let todayMonth = Calendar.current.component(.month, from: today)
                let todayDay = Calendar.current.component(.day, from: today)
                
                if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                    todoData.append(i)
                }
            }
            self.todoListButton.isHidden = true
            self.todoTableView.reloadData()
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func todoUp(_ notification: Notification){
        for subview in view.subviews {
            if subview == calenderView{
                subview.removeFromSuperview()
            }
        }
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(todoSeparatorBar)
        todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoSeparatorBar.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor).isActive = true
        
        view.bringSubviewToFront(todoListButton)
        todoListButton.isHidden = false
//        view.bringSubviewToFront(passiveScheduleAddButton)
        
        NotificationCenter.default.post(name: NSNotification.Name("changeToUp"), object: nil)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        //마지막 선택된 날짜로 투두 테이블 표현
        if let currentSelectedDateTime = notification.userInfo?["currentCellDateTime"] as? Date {
            todoData = []
            for i in posterTuples {
                if i.0 <= currentSelectedDateTime && i.1 >= currentSelectedDateTime {
                    todoData.append(i)
                }
            }
            let currentCellMonth = Calendar.current.component(.month, from: currentSelectedDateTime)
            let currentCellDay = Calendar.current.component(.day, from: currentSelectedDateTime)
            
            todoList.text = "\(currentCellMonth)월 \(currentCellDay)일"
            self.todoTableView.reloadData()
        }
        todoStatus = -1
    }
    
    @objc func todoTableTapped(){
        NotificationCenter.default.post(name: NSNotification.Name("changeToDown"), object: nil)
        
        for subview in view.subviews {
            if subview == todoTableView || subview == todoSeparatorBar{
                subview.removeFromSuperview()
            }
        }
        
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        todoListButton.isHidden = true
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = 1
    }
    @objc func moveNextMonthBySwipe() {
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
        todoTableTapped()
        calenderView.monthView.rightPanGestureAction()
    }
    
    @objc func movePreviousMonthBySwipe() {
        todoTableTapped()
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
        calenderView.monthView.leftPanGestureAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension CalenderVC: UITableViewDelegate,UITableViewDataSource {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoData.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "지우기"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? todoCell else {
            return .init()
        }
        let todayDay = Calendar.current.component(.day, from: Date())
        let todoListDay = Calendar.current.component(.day, from: todoData[indexPath.row].1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // FIXME: 주어진 카테고리값에 따라서 라인의 색깔을 바꿔야함
        if indexPath.row % 3 == 0 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
        } else if indexPath.row % 3 == 1 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 7/255, green: 166/255, blue: 255/255, alpha: 1.0)
        } else if indexPath.row % 3 == 2 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 254/255, green: 109/255, blue: 109/255, alpha: 1.0)
        }
        
        var categoryLabel = ""
        switch todoData[indexPath.row].5 {
        case 0:
            categoryLabel = "공모전"
        case 1:
            categoryLabel = "대외활동"
        case 2:
            categoryLabel = "동아리"
        case 3:
            categoryLabel = "교내공지"
        case 4:
            categoryLabel = "채용"
        default:
            categoryLabel = "기타"
        }
        
        cell.categoryLabel.text = categoryLabel
        cell.contentLabel.text = "\(todoData[indexPath.row].4)"
        
        let todoDataStartMonth = Calendar.current.component(.month, from: todoData[indexPath.row].0)
        let todoDataStartDay = Calendar.current.component(.day, from: todoData[indexPath.row].0)
        
        let todoDataEndMonth = Calendar.current.component(.month, from: todoData[indexPath.row].1)
        let todoDataEndDay = Calendar.current.component(.day, from: todoData[indexPath.row].1)
        
        cell.dateLabel.text = "\(todoDataStartMonth).\(todoDataStartDay) ~ \(todoDataEndMonth).\(todoDataEndDay)"
        cell.leftedDay.text = "\(todoListDay-todayDay)"
    
        cell.dateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        cell.leftedDay.font = UIFont.systemFont(ofSize: 34.0, weight: .medium)
        
        return cell
    }
    
    //MARK: UITableviewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        let nav = storyBoard.instantiateViewController(withIdentifier: "DetailPoster") as! CalendarDetailVC
        
        let defaults = UserDefaults.standard
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    if todoData[indexPath.row].4 == poster.posterName! {
                        nav.Poster = poster
                    }
                }
            }
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "완료", handler: { (action, indexPath) in
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제", handler: { (action, indexPath) in
            let defaults = UserDefaults.standard
            
            if let posterData = defaults.object(forKey: "poster") as? Data {
                if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                    for i in 0...posterInfo.count-1 {
                        if posterInfo[i].posterName! == self.todoData[indexPath.row].4 {
                            self.todoData.remove(at: i)
                        }
                    }
                }
            }
            tableView.reloadData()
        })
        
        deleteAction.backgroundColor = UIColor.red
        editAction.backgroundColor = UIColor.blue
        
        return [editAction, deleteAction]
    }
}

fileprivate extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

