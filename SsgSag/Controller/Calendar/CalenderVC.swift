import UIKit

class CalenderVC: UIViewController {
    
    private var todoStatus: todoTableStatus = .todoShow
    
    private var daySelectedStatus: daySelectState = .notSelected
    
    private var todoTableData:[Posters] = []
    
    private var posters:[Posters] = []
    
    private var eventDictionary: [Int:[event]] = [:]
    
    private var calendarViewBottomAnchor: NSLayoutConstraint?
    
    private var calendarServiceImp: CalendarService?
    
    static let sharedTableViewHeight: CGFloat = 89
    
    var monthHeaderView: VAMonthHeaderView = {
        let monthHeaderView = VAMonthHeaderView(frame: CGRect.init())
        let appereance = VAMonthHeaderViewAppearance(
                dateFormat: "LLLL"
            )
        monthHeaderView.appearance = appereance
        return monthHeaderView
    }()
    
    var weekDaysView: VAWeekDaysView =  {
        let defaultCalendar: Calendar = {
            var calendar = Calendar.current
            calendar.firstWeekday = 1
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            return calendar
        }()
        
        let weekDaysView = VAWeekDaysView(frame: CGRect.init())
        let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
        weekDaysView.appearance = appereance
        return weekDaysView
        
    }()
    
    private lazy var calenderView: VACalendarView = {
        let calendarView = VACalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.scrollDirection = .horizontal
        return calendarView
    }()
    
    private let applySuccess: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(moveToApplySuccessVC), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "btCheckApplied"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let todoSeparatorBar: UIView = {
        let todoView = UIView()
        todoView.backgroundColor = UIColor.rgb(red: 228, green: 228, blue: 228)
        todoView.translatesAutoresizingMaskIntoConstraints = false
        return todoView
    }()
    
    private let todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tabToDownButtonView: UIImageView = {
        let downView = UIImageView()
        downView.translatesAutoresizingMaskIntoConstraints = false
        downView.image = UIImage(named: "icListTabDown")
        return downView
    }()
    
    private let todoList: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.text = "투두리스트"
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        return label
    }()
    
    private let separatorLine: UIView = {
        let separ = UIView()
        separ.translatesAutoresizingMaskIntoConstraints = false
        return separ
    }()
    
    enum daySelectState: Int {
        case selected = 1
        case notSelected = 0
    }
    
    // MARK: - lifeCycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bgColor
        
        setService()
        
        setupContentView()
        
        setupGesture()
        
        setNotificationObserver()
        
        setPosters()
        
        setTodoTableView()
        
        monthHeaderView.delegate = self
        calenderView.dayViewAppearanceDelegate = self
        calenderView.monthViewAppearanceDelegate = self
        calenderView.calendarDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setTodoColor()
    }
    
    private func setTodoColor() {
        let color1 = UIColor.rgb(red: 251, green: 251, blue: 251)
        let color2 = UIColor.rgb(red: 249, green: 249, blue: 249)
        let _ = UIColor.rgb(red: 246, green: 246, blue: 246)
        
        todoSeparatorBar.setGradientBackGround(colorOne: color1, colorTwo: color2, frame: todoSeparatorBar.bounds)
        
        todoTableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    }
    
    @objc private func moveToApplySuccessVC() {
        let storyBoard = UIStoryboard(name: StoryBoardName.apply, bundle: nil)
        let navigationVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.applySuccessViewController) as! UINavigationController
        
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    func setService(_ calendarService: CalendarService = CalendarServiceImp()) {
        self.calendarServiceImp = calendarService
    }
    
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name(NotificationName.addUserDefaults), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sortSpecificDayOftodoList), name: NSNotification.Name(rawValue: NotificationName.didselectItem), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteUserDefaults), name: NSNotification.Name(rawValue: NotificationName.deleteUserDefaults), object: nil)
    }
    
    @objc func deleteUserDefaults() {
        todoTableData = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
        
        todoTableView.reloadData()
    }
    
    /// add poster data to userDefault
    @objc func addUserDefaults() {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
            
            guard let posterEndDateString = poster.posterEndDate else { return }
            
            guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else { return }
            
            let posterMonth = Calendar.current.component(.month, from: posterEndDate)
            let posterDay = Calendar.current.component(.day, from: posterEndDate)
            
            let todayMonth = Calendar.current.component(.month, from: Date())
            let todayDay = Calendar.current.component(.day, from: Date())
            
            if posterMonth == todayMonth &&
                posterDay - todayDay > 0 {
                
                todoTableData.append(poster)
            }
            
        }
        
        todoTableView.reloadData()
    }
    
    /// setup todoView
    ///
    /// setup the todoView using autolayout
    func setupContentView() {
        
        view.addSubview(todoTableView)
        view.addSubview(todoSeparatorBar)
        
        todoSeparatorBar.addSubview(tabToDownButtonView)
        todoSeparatorBar.addSubview(todoList)
        todoSeparatorBar.addSubview(separatorLine)
        
        view.addSubview(calenderView)
        calenderView.setup()
        
        let todoTableViewHeightAnchor = todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        todoTableViewHeightAnchor.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todoTableViewHeightAnchor,
            
            todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor),
            todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            todoSeparatorBar.heightAnchor.constraint(equalToConstant: 48),
            
            todoList.leadingAnchor.constraint(equalTo: todoSeparatorBar.leadingAnchor, constant: 18),
            todoList.bottomAnchor.constraint(equalTo: todoSeparatorBar.bottomAnchor),
            todoList.centerYAnchor.constraint(equalTo: todoSeparatorBar.centerYAnchor),
            
            tabToDownButtonView.centerYAnchor.constraint(equalTo: todoSeparatorBar.centerYAnchor),
            tabToDownButtonView.leadingAnchor.constraint(equalTo: todoList.trailingAnchor, constant: 13),
            
            separatorLine.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor),
            separatorLine.leftAnchor.constraint(equalTo: todoSeparatorBar.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: todoSeparatorBar.rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calenderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calenderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor)
            ])
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        todoTableView.separatorStyle = .none
        
        separatorLine.backgroundColor = UIColor.rgb(red: 228, green: 228, blue: 228)
        
        let currentSelectedDateMonth = Calendar.current.component(.month, from: Date())
        
        let currentSelectedDateDay = Calendar.current.component(.day, from: Date())
        
        todoList.text = "\(currentSelectedDateMonth)월 \(currentSelectedDateDay)일 투두리스트"
        
    }
    
    func setupGesture() {
        
        let todoTableShow = UISwipeGestureRecognizer(target: self,
                                                     action: #selector(todoTableSwipeUp))
        let todoTableSwipeHide = UISwipeGestureRecognizer(target: self,
                                                          action: #selector(hideTodoTable))
        let todoTableHide = UITapGestureRecognizer(target: self,
                                                   action: #selector(hideTodoTable))
        
        let movePreviousMonth = UISwipeGestureRecognizer(target: self,
                                                         action: #selector(movePreviousMonthBySwipe))
        
        let moveNextMonth = UISwipeGestureRecognizer(target: self, action: #selector(moveNextMonthBySwipe))
        
        
        calenderView.gestureRecognizers = [todoTableShow, todoTableSwipeHide]
        
        movePreviousMonth.direction = .left
        moveNextMonth.direction = .right
        
        todoTableShow.direction = .up
        todoTableSwipeHide.direction = .down
        
        todoSeparatorBar.gestureRecognizers = [todoTableHide]
    }
    
    private func setTodoTableView() {
        
        for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
            
            guard let posterEndDateString = poster.posterEndDate else { return }
            
            guard let posterEndDate = DateFormatter.genericDateFormatter.date(from: posterEndDateString) else { return }
            
            let dayInterval = Calendar.current.dateComponents([.day],
                                                              from: Date(),
                                                              to: posterEndDate)
            
            guard let interval = dayInterval.day else {return}
            
            if interval > 0  {
                todoTableData.append(poster)
            }
            
        }
        
        sortOrderUsingFavorite(&todoTableData)
    }
    
    private func setPosters(){
        
        posters = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
        
        posters.sort{$0.posterEndDate! < $1.posterEndDate!}
        
    }
    
    fileprivate func setTodoListData(_ today: Date) {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
            
            guard let posterEndDateString = poster.posterEndDate else { return }
            
            guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else { return }
            
            let dayInterval = Calendar.current.dateComponents([.day],
                                                              from: Date(), to: posterEndDate)
            
            guard let interval = dayInterval.day else {return}
            
            if interval > 0  {
                todoTableData.append(poster)
            }
        }
    }
    
    /// day did selected
    ///
    /// - Use this func for sort todoList of specific day
    @objc func sortSpecificDayOftodoList(_ notification: Notification) {
        
        if todoStatus == .todoNotShow {
            setCalendarVCWhenTODOShow()
            todoStatus = .todoShow
        }
        
        daySelectedStatus = .selected
        
        //현재 선택된 날짜에 따라
        guard let currentSelectedDateTime = notification.userInfo?["currentCellDateTime"] as? Date else {
            return
        }
        
        todoTableData = []
        
        let currentSelectedDateYear = Calendar.current.component(.year, from: currentSelectedDateTime)
        
        let currentSelectedDateMonth = Calendar.current.component(.month, from: currentSelectedDateTime)
        
        let currentSelectedDateDay = Calendar.current.component(.day, from: currentSelectedDateTime)
        
        let todayYear = Calendar.current.component(.year, from: Date())
        
        let todayMonth = Calendar.current.component(.month, from: Date())
        
        let todayDay = Calendar.current.component(.day, from: Date())
        
        var currentDateString = "\(currentSelectedDateMonth)월 \(currentSelectedDateDay)일"
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        // 오늘일 경우 투두리스트의 모든 데이터를 보여준다.
        if currentSelectedDateYear == todayYear &&
            currentSelectedDateMonth == todayMonth &&
            currentSelectedDateDay == todayDay {
            
            todoTableData = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
            currentDateString = "\(currentSelectedDateMonth)월 \(currentSelectedDateDay)일 투두리스트"
        } else {
            
            for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
                
                guard let posterEndDateString = poster.posterEndDate else { return }
                
                guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else { return }
                
                let posterTupleEndDateYear = Calendar.current.component(.year, from: posterEndDate)
                
                let posterTupleEndDateMonth = Calendar.current.component(.month, from: posterEndDate)
                
                let posterTupleEndDateDay = Calendar.current.component(.day, from: posterEndDate)
                
                //포스터의 날짜가 현재 달력에 선택된 날짜와 같은 것들만 표시해준다.
                if posterTupleEndDateYear == currentSelectedDateYear &&
                    posterTupleEndDateMonth == currentSelectedDateMonth &&
                    posterTupleEndDateDay == currentSelectedDateDay {
                    
                    todoTableData.append(poster)
                }
            }
        }
        
        sortOrderUsingFavorite(&todoTableData)
        
        todoList.text = currentDateString
        todoSeparatorBar.bringSubviewToFront(todoList)
        
        todoTableView.reloadData()
        //calenderView.calendarCollectionView.reloadData()
    }
    
    func sortOrderUsingFavorite(_ todoList: inout [Posters]) {
        
        var notFavorite: [Posters] = []
        var favorite: [Posters] = []
        
        for todo in todoList {
            
            guard let posterIdx = todo.posterIdx else {return}
            
            guard let isFavorite = UserDefaults.standard.object(forKey: "favorite\(posterIdx)") as? Int else {
                notFavorite.append(todo)
                continue
            }
            
            if isFavorite == 0 {
                notFavorite.append(todo)
            } else {
                favorite.append(todo)
            }
        }
        
        todoList = favorite + notFavorite
    }
    
    @objc func addPassiveDate() {
        let storyboard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.addPassiveDataNavigationController)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func todoTableSwipeUp(){
        
        setCalendarVCWhenTODOShow()
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.changeToUp), object: nil)
        
        if daySelectedStatus == .notSelected {
            
            todoTableData = []
            
            let today = Date()
            
            let dateFormatter = DateFormatter.genericDateFormatter
            
            for poster in posters {
                
                guard let posterEndDateString = poster.posterEndDate else {
                    return
                }
                
                guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else {
                    return
                }
                
                let posteurTupleMonth = Calendar.current.component(.month, from: posterEndDate)
                let posterTupleDay = Calendar.current.component(.day, from: posterEndDate)
                
                let todayMonth = Calendar.current.component(.month, from: today)
                let todayDay = Calendar.current.component(.day, from: today)
                
                if posteurTupleMonth == todayMonth && (posterTupleDay - todayDay) > 0{
                    todoTableData.append(poster)
                }
            }
            self.todoTableView.reloadData()
        }
        todoStatus = .todoShow
        //calenderView.calendarCollectionView.reloadData()
    }
    
    func setCalendarVCWhenTODOShow() {
        for subview in view.subviews {
            if subview == calenderView {
                subview.removeFromSuperview()
            }
        }
        
        view.addSubview(todoTableView)
        view.addSubview(todoSeparatorBar)
        view.addSubview(calenderView)
        
        todoSeparatorBar.addSubview(separatorLine)
        
        let todotableViewBottomAnchor: NSLayoutConstraint = todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        
        todotableViewBottomAnchor.priority = UILayoutPriority(750)
        
        calendarViewBottomAnchor = calenderView.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor)
        calendarViewBottomAnchor?.identifier = "calendarViewBottomAnchor"
        
        let todoTableViewHeightAnchor = todoTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        todoTableViewHeightAnchor.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todoTableViewHeightAnchor,
            
            todoSeparatorBar.bottomAnchor.constraint(equalTo: todoTableView.topAnchor),
            todoSeparatorBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            todoSeparatorBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            todoSeparatorBar.heightAnchor.constraint(equalToConstant: 48),
            
            separatorLine.bottomAnchor.constraint(equalTo: todoSeparatorBar.topAnchor),
            separatorLine.leftAnchor.constraint(equalTo: todoSeparatorBar.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: todoSeparatorBar.rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calenderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calenderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendarViewBottomAnchor ?? .init(),
            
            ])
        
        todoTableView.rowHeight = todoTableView.frame.height / 3
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
    }
    
    func setCalendarVCWhenTODOHide() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.changeToDown), object: nil)
        
        for subview in view.subviews {
            if subview == todoTableView || subview == todoSeparatorBar {
                subview.removeFromSuperview()
            }
        }
        
        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        view.layoutIfNeeded()
    }
    
    @objc func hideTodoTable(){
        setCalendarVCWhenTODOHide()
        
        todoStatus = .todoNotShow
        
        //calenderView.calendarCollectionView.reloadData()
    }
    
    @objc func moveNextMonthBySwipe() {
        hideTodoTable()
        //calenderView.monthView.rightPanGestureAction()
    }
    
    @objc func movePreviousMonthBySwipe() {
        hideTodoTable()
        //calenderView.monthView.leftPanGestureAction()
    }
    
}

// MARK: - TableViewDelegate
extension CalenderVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoTableData.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "지우기"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else {
            return .init()
        }
        
        todoTableViewCell.todoCellDelegate = self
        
        todoTableViewCell.poster = todoTableData[indexPath.row]
        
        return todoTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
        let CalendarDetailVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.detailPosterViewController) as! CalendarDetailVC
        
        let posterInfo = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
        
        for poster in posterInfo {
            guard let posterName = todoTableData[indexPath.row].posterName else { return }
            if posterName == poster.posterName! {
                CalendarDetailVC.Poster = poster
            }
        }
        
        present(CalendarDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CalenderVC.sharedTableViewHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "완료") { action, indexPath in
            
            guard let posterIdx = self.todoTableData[indexPath.row].posterIdx else {return}
            
            UserDefaults.standard.setValue(1, forKey: "completed\(posterIdx)")
            
            let posterComplete = CalendarServiceImp()
            posterComplete.reqeustComplete(posterIdx) { (dataResponse) in
                
                guard let statusCode = dataResponse.value?.status else {return}
                
                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
                
                switch httpStatusCode {
                case .favoriteSuccess:
                    print("CompleteApplyPoster isSuccessfull")
                case .serverError:
                    print("CompleteApplyPoster serverError")
                case .dataBaseError:
                    print("CompleteApplyPoster dataBaseError")
                default:
                    break
                }
            }
            tableView.reloadData()
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제", handler: { (action, indexPath) in
        
            let posterInfo = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
            
            var userDefaultsData = posterInfo
            
            for index in 0...posterInfo.count-1 {
                if posterInfo[index].posterName! == self.todoTableData[indexPath.row].posterName! {
                    
                    userDefaultsData.remove(at: index)
                    
                    let posterDelete = CalendarServiceImp()
                    guard let posterIdx = self.todoTableData[indexPath.row].posterIdx else {return}
                    posterDelete.requestDelete(posterIdx) { (dataResponse) in
                        
                        guard let statusCode = dataResponse.value?.status else {return}
                        
                        guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
                        
                        switch httpStatusCode {
                        case .favoriteSuccess:
                            print("DeletePoster isSuccessfull")
                        case .serverError:
                            print("DeletePoster serverError")
                        case .dataBaseError:
                            print("DeletePoster dataBaseError")
                        default:
                            break
                        }
                    }
                    
                }
            }
            
            StoreAndFetchPoster.shared.storePoster(posters: userDefaultsData)
            
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.deleteUserDefaults), object: nil)
        })
        
        editAction.backgroundColor = UIColor.rgb(red: 49, green: 137, blue: 240)
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [deleteAction, editAction]
    }
}

extension CalenderVC: todoCellDelegate {
    
    func changeOrderOfTodoList() {
        sortOrderUsingFavorite(&todoTableData)
        todoTableView.reloadData()
        self.todoTableView.layoutIfNeeded()
    }
    
}

extension CalenderVC: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calenderView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calenderView.previousMonth()
    }
    
}

extension CalenderVC: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension CalenderVC: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .gray
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension CalenderVC: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calenderView.startDate = dates.last ?? Date()
        print(dates)
    }
    
}


