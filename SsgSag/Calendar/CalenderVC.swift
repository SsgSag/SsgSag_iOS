
import UIKit

enum MyTheme {
    case light
    case dark
}

class CalenderVC: UIViewController{
    var todoStatus = 1
    var theme = MyTheme.dark
    var selectedStatus = 0
    
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
    
    var todoData:[(Date, Date, Int, Int, String, Int)] = []
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
        
        let defaults = UserDefaults.standard
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo { //userDefaults에 있는 모든 poster 정보를 불러온다.
                    
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    let inputData:(Date, Date, Int, Int, String, Int) = (posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0)
                    
                    if isDuplicatePosterTuple(posterTuples, input: inputData) == false {
                        posterTuples.append(inputData)
                    }
                }
            }
        }
        
        let today = Date()
        
        for posterTuple in posterTuples {
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
    
    //모든 poster 데이터 지우기
    func removeDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "poster")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removeDefaults()
        Style.themeLight()
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
        calenderView.backgroundColor = .clear
        
        let todoTableShow = UISwipeGestureRecognizer(target: self, action: #selector(todoTableSwipeUp))
        let todoTableHide = UITapGestureRecognizer(target: self, action: #selector(todoTableTapped))
        
        let movePreviousMonth = UISwipeGestureRecognizer(target: self, action: #selector(movePreviousMonthBySwipe))
        let moveNextMonth = UISwipeGestureRecognizer(target: self, action: #selector(moveNextMonthBySwipe))
        
        calenderView.gestureRecognizers = [movePreviousMonth, moveNextMonth,todoTableShow]
        movePreviousMonth.direction = .left
        moveNextMonth.direction = .right
        
        todoTableShow.direction = .up
        todoSeparatorBar.gestureRecognizers = [todoTableHide]
        
        view.addSubview(todoTableView)
        todoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        todoTableView.backgroundColor = UIColor(displayP3Red: 251 / 255, green: 251 / 255, blue: 251 / 255, alpha: 1.0)
        
        todoTableView.rowHeight = view.frame.height / 13
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(todoCell.self, forCellReuseIdentifier: "todoCell")
        
        todoTableView.separatorStyle = .none
        todoTableView.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        
        
        view.addSubview(todoSeparatorBar)
        todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor).isActive = true
        todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        todoSeparatorBar.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        todoSeparatorBar.addSubview(donwTodoView)
        donwTodoView.topAnchor.constraint(equalTo: todoSeparatorBar.topAnchor, constant: 10).isActive = true
        donwTodoView.centerXAnchor.constraint(equalTo: todoSeparatorBar.centerXAnchor).isActive = true
        donwTodoView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        donwTodoView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        todoSeparatorBar.addSubview(todoList)
        todoList.centerXAnchor.constraint(equalTo: todoSeparatorBar.centerXAnchor).isActive = true
        todoList.bottomAnchor.constraint(equalTo: todoSeparatorBar.bottomAnchor).isActive = true
        todoList.topAnchor.constraint(equalTo: donwTodoView.bottomAnchor, constant: 10).isActive = true
        todoList.heightAnchor.constraint(equalToConstant: 21).isActive = true
        todoList.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        
        todoSeparatorBar.addSubview(separatorLine)
        separatorLine.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor).isActive = true
        
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
        view.addSubview(todoListButton)
        todoListButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-34).isActive = true
        todoListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoListButton.widthAnchor.constraint(equalToConstant: 135).isActive = true
        todoListButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        todoListButton.isHidden = true
        todoListButton.addTarget(self, action: #selector(changeTodoTable), for: .touchUpInside)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaults = UserDefaults.standard
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                }
            }
        }
        
        //긴날짜 순으로 정렬
        posterTuples.sort{$0.1 < $1.1}
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayDidSelected(_:)), name: NSNotification.Name(rawValue: "todoUp"), object: nil)
        
    }
    
    //투두 리스트 테이블 표현
    //현재 선택된 cell의 색깔을 없애고
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
        
//        view.bringSubviewToFront(passiveScheduleAddButton)
        todoListButton.isHidden = true
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        todoStatus = 1
    }
    @objc func moveNextMonthBySwipe() {
        //print("왼쪽으로")
        NotificationCenter.default.post(name: NSNotification.Name("calendarSwipe"), object: nil)
        todoTableTapped()
        calenderView.monthView.rightPanGestureAction()
    }
    
    @objc func movePreviousMonthBySwipe() {
        //print("오른쪽으로")
        todoTableTapped()
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

extension CalenderVC: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! todoCell
        
        let todayDay = Calendar.current.component(.day, from: Date())
        let todoListDay = Calendar.current.component(.day, from: todoData[indexPath.row].1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if indexPath.row % 3 == 0 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
        } else if indexPath.row % 3 == 1 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 7/255, green: 166/255, blue: 255/255, alpha: 1.0)
        } else if indexPath.row % 3 == 2 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 254/255, green: 109/255, blue: 109/255, alpha: 1.0)
        }
        
        if todoData[indexPath.row].5 == 0 {
            cell.categoryLabel.text = "공모전"
        } else if todoData[indexPath.row].5 == 1 {
            cell.categoryLabel.text = "대외활동"
        } else if todoData[indexPath.row].5 == 2 {
            cell.categoryLabel.text = "동아리"
        } else if todoData[indexPath.row].5 == 3 {
            cell.categoryLabel.text = "교내공지"
        } else if todoData[indexPath.row].5 == 4 {
            cell.categoryLabel.text = "채용"
        } else {
            cell.categoryLabel.text = "기타"
        }

        cell.categoryLabel.textColor = UIColor.rgb(red: 97, green: 118, blue: 221)
        cell.contentLabel.text = "\(todoData[indexPath.row].4)"
        cell.contentLabel.numberOfLines = 2
        cell.contentLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        
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
}

//todo tableview의 셀
class todoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        leftView.translatesAutoresizingMaskIntoConstraints = false
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
        sv.widthAnchor.constraint(equalToConstant: 1).isActive = true
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
    
    let newImage: UIImageView = {//남은 날짜 밑에 (일 남음 텍스트)
        let lb = UIImageView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    func setupCell(){
        self.selectionStyle = .none
        
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        borderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        borderView.backgroundColor = .white
        borderView.addSubview(leftLineView)
        
        leftLineView.leftAnchor.constraint(equalTo: borderView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        leftLineView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 8.5).isActive = true
        
        borderView.addSubview(categoryLabel)
        categoryLabel.text = "Label"
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        categoryLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        
        borderView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor ,constant: 2).isActive
            = true
        contentLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        contentLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        
        borderView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 3).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        dateLabel.textColor = UIColor.rgb(red: 139, green: 139, blue: 139)
        
        borderView.addSubview(separatorView)
        separatorView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -70).isActive = true
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
        borderView.addSubview(leftedDay)
        leftedDay.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -28).isActive = true
        leftedDay.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        leftedDay.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        
        borderView.addSubview(leftedDayBottom)
        leftedDayBottom.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8).isActive = true
        leftedDayBottom.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -21).isActive = true
        leftedDayBottom.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        leftedDayBottom.textColor = UIColor.rgb(red: 134, green: 134, blue: 134)
        
        borderView.addSubview(newImage)
        newImage.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -20).isActive = true
        newImage.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 17).isActive = true
        newImage.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant:-17).isActive = true
        newImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        newImage.image = UIImage(named: "icTimePassed")
        newImage.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(rightItemHidden), name: NSNotification.Name("rightItemHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundColor), name: NSNotification.Name("changeBackgroundColor"), object: nil)
    }
    
    @objc func rightItemHidden() {
        leftedDay.isHidden = true
        leftedDayBottom.isHidden = true
        newImage.isHidden = false
        
    }
    @objc func changeBackgroundColor() {
        leftedDay.isHidden = false
        leftedDayBottom.isHidden = false
        newImage.isHidden = true
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
