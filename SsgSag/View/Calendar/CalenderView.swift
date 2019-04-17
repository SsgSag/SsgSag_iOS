
import UIKit

class CalenderView: UIView, MonthViewDelegate {
    
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]//12달
    
    private var currentMonth: Int = 0
    
    private var currentYear: Int = 0
    
    private var presentMonthIndex = 0
    
    private var presentYear = 0
    
    private var currentDay = 0
    
    private var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7) 일:1,월:2 ~ 금:6,토:7
    
    private var numberOfCurrentMonthDays = 0
    
    private var eventDictionary: [Int:[event]] = [:]
    
    private var lastSelectedDate: Date?
    
    private var lastSelectedIndexPath: IndexPath?
    
    private var todaysIndexPath: IndexPath?
    
    private var todoButtonTapped = false
    
    static private let leapYear = 4
    
    static private let leapMonth = 2
    
    static private let leapDays = 29
    
    
    // MARK: - init func
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCalenderViewColor()
        
        initMonthAndCalendarCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoListButtonAction), name: NSNotification.Name("todoListButtonAction"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeUserDefaultsAndReloadData), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeUserDefaultsAndReloadData), name: NSNotification.Name(rawValue: "deleteUserDefaults"), object: nil)
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        Style.themeLight()
        initMonthAndCalendarCollectionView()
    }
    
    // MARK: - Notification func
    @objc func changeUserDefaultsAndReloadData() {
        self.calendarCollectionView.reloadData()
    }
    
    @objc func todoListButtonAction() { //투두리스트를 표현하자
        todoButtonTapped = true
        if let index = lastSelectedIndexPath {
            calendarCollectionView.reloadItems(at: [index])
        }
    }
    
    static func getPosterUsingUserDefaults() -> [Posters] {
        
        guard let posterData = UserDefaults.standard.object(forKey: "poster") as? Data else {
            return []
        }
        
        guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else {
            return []
        }
        
        return posterInfo
    }
    
    static func isDuplicatePosterTuple(_ posterTuples:[Posters], input: Posters) -> Bool {
        
        for poster in posterTuples {
            
            if poster.posterName! == input.posterName! {
                return true
            }
            
        }
        
        return false
    }
    
    private func setCalenderViewColor() {
        
        monthView.monthName.textColor = .black
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for day in 0..<7 {
            (weekdaysView.myStackView.subviews[day] as! UILabel).textColor = .black
            if day == 0 {
                (weekdaysView.myStackView.subviews[day] as! UILabel).textColor = .red
            }
        }
        
    }
    
    func initMonthAndCalendarCollectionView() {
        
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currentDay = Calendar.current.component(.day, from: Date())
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //윤년 계산 4년에 한번씩 2월은 29일
        if currentMonth == CalenderView.leapMonth && currentYear % CalenderView.leapYear == 0 {
            numOfDaysInMonth[currentMonth-1] = CalenderView.leapDays
        }
        
        presentMonthIndex = currentMonth
        presentYear = currentYear
        
        setupViews()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        calendarCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonth = monthIndex + 1 //월+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 { //4년에 한번 29일까지
            
            let leapDays = currentYear % CalenderView.leapYear == 0 ? CalenderView.leapDays : 28
            numOfDaysInMonth[monthIndex] = leapDays
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        self.calendarCollectionView.reloadData()
        monthView.btnLeft.isEnabled = true
    }
    
    func setupViews() {
        //월
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 28).isActive=true
        monthView.delegate = self
        
        //월화수목금토
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 4).isActive=true
        weekdaysView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        weekdaysView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        let calendarCollectionViewBottonAnchor = calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        calendarCollectionViewBottonAnchor.priority = UILayoutPriority(750)
        calendarCollectionViewBottonAnchor.identifier = "calendarCollectionViewBottonAnchor"
        addSubview(calendarCollectionView)
        
        calendarCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 4).isActive = true
        calendarCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        calendarCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        calendarCollectionViewBottonAnchor.isActive = true
    }
    
    let monthView: MonthView = {
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.isScrollEnabled = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegate
extension CalenderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1 > 35 {
            numberOfCurrentMonthDays = 42
        }else {
            numberOfCurrentMonthDays = 35
        }
        
        return numberOfCurrentMonthDays
    }
    
    private func setbeforeMonthAndYear(beforeMonthIndex:inout Int, beforeYear: inout Int) {
        if currentMonth == 1 {
            beforeMonthIndex = 12
            beforeYear = currentYear
        } else {
            beforeMonthIndex = currentMonth - 1
            beforeYear = currentYear
        }
    }
    
    private func setbeforeMonthCount(beforeMonthIndex: Int) -> Int {
        
        if beforeMonthIndex == 2 {
            if currentYear % 4 == 0 {
                return numOfDaysInMonth[beforeMonthIndex-1] + 1
            } else {
                return numOfDaysInMonth[beforeMonthIndex-1]
            }
        }
        
        return numOfDaysInMonth[beforeMonthIndex-1]
    }
    
    private func setNextYearAndMonth(nextYear: inout Int, nextMonth: inout Int) {
        if currentMonth == 12 {
            nextYear = currentYear + 1
            nextMonth = 1
        } else {
            nextYear = currentYear
            nextMonth = currentMonth + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DayCollectionViewCell else {
            return .init()
        }
        
        var beforeMonthIndex = 0
        var beforeYear = 0
        
        var nextYear = 0
        var nextMonth = 0
        var nextMonthDay = 0
        
        setbeforeMonthAndYear(beforeMonthIndex: &beforeMonthIndex, beforeYear: &beforeYear)
        
        let beforeMonthCount = setbeforeMonthCount(beforeMonthIndex: beforeMonthIndex)
        
        setNextYearAndMonth(nextYear: &nextYear, nextMonth: &nextMonth)
        
        let shouldShowBeforeMonthDay: Bool = indexPath.item <= firstWeekDayOfMonth - 2
        
        if shouldShowBeforeMonthDay { //이전달의 표현해야 하는 날짜들
            
            let beforeMonthDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row + 2
            cell.isHidden = true
            cell.lbl.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
            cell.lbl.text = "\(beforeMonthDay)"
            cell.isUserInteractionEnabled = false
            
        } else { //현재달에 표현해야 하는 날짜들
            
            let shouldShowDay = indexPath.row - firstWeekDayOfMonth + 2
            
            cell.isHidden = false
            cell.lbl.text = "\(shouldShowDay)"
            cell.isUserInteractionEnabled = true
            cell.lbl.textColor = UIColor.black
            cell.lbl.backgroundColor = .clear
            
            if shouldShowDay == currentDay &&
                currentYear == presentYear &&
                currentMonth == presentMonthIndex { //오늘날짜
                
                todaysIndexPath = indexPath

                guard let lbl = cell.subviews[1] as? UILabel else {
                    return .init()
                }
                
                lbl.layer.cornerRadius = lbl.frame.height / 2
                lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
                lbl.textColor = UIColor.white
            }
            
            if indexPath.row % 7 == 0 { //일요일
                cell.lbl.textColor = .red
            }
            
            nextMonthDay = (shouldShowDay + firstWeekDayOfMonth - 1) - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1)
            //다음달 일수 출력
            if nextMonthDay >= 1 {
                cell.isHidden = true
                cell.lbl.text="\(nextMonthDay)"
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = .lightGray
            }
        }
        
        var cellYear = currentYear
        var cellMonth = currentMonth
        var cellDay = indexPath.row - firstWeekDayOfMonth + 2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        
        var currentCellDateTime = formatter.date(from: cellDateString)
        
        eventDictionary[indexPath.row] = []
        
        for poster in CalenderView.getPosterUsingUserDefaults() {
            if currentCellDateTime != nil {
                
                guard let posterEndDateString = poster.posterEndDate else { return .init() }
                
                guard let posterEndDate = formatter.date(from: posterEndDateString) else {return .init()}
                
                guard let posterName = poster.posterName else { return .init()}
                
                guard let posterCategortIdx = poster.categoryIdx else { return .init()}
                
                let currentPosterYear = Calendar.current.component(.year, from: posterEndDate)
                let currentPosterMonth = Calendar.current.component(.month, from: posterEndDate)
                let currentPosterDay = Calendar.current.component(.day, from: posterEndDate)
                
                if (cellYear == currentPosterYear) &&
                    (cellMonth == currentPosterMonth) &&
                    (cellDay == currentPosterDay) {
                    
                    eventDictionary[indexPath.row]?.append(event(eventDate: posterEndDate,
                                                                 title: posterName,
                                                                 categoryIdx: posterCategortIdx)
                                                                    )
                }
                
            }
        }
        
        cell.drawDotAndLineView(indexPath, eventDictionary: eventDictionary)
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        
        //FIXME: - 여기서 처음 날짜 그려지는 문제 발생
//        if lastSelectedDate != nil &&
//            currentDay == cellDay &&
//            currentYear == presentYear &&
//            currentMonth == presentMonthIndex{
//
//            todaysIndexPath = indexPath
//            let lbl = cell.subviews[1] as! UILabel
//            lbl.layer.cornerRadius = lbl.frame.height / 2
//            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
//            lbl.textColor = UIColor.white
//        }
        
        if currentCellDateTime == nil {
            //전달이면
            if indexPath.row < 15 {
                cellYear = beforeYear
                cellMonth = beforeMonthIndex
                cellDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
                currentCellDateTime = formatter.date(from: cellDateString)
            } else {
                cellYear = nextYear
                cellMonth = nextMonth
                cellDay = nextMonthDay
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
                currentCellDateTime = formatter.date(from: cellDateString)
            }
        }
        
        let calendar = Calendar.current
        let componentsCell = calendar.dateComponents([.year, .month, .day], from: currentCellDateTime!)
        
        guard let lastSelectDate = lastSelectedDate else {
            return cell
        }
        
        let componentsSelectedCell = calendar.dateComponents([.year, .month, .day], from: lastSelectDate)
        
        if componentsCell.month! == componentsSelectedCell.month! &&
            componentsCell.year! == componentsSelectedCell.year! &&
            componentsCell.day! == componentsSelectedCell.day! &&
            todoButtonTapped == false {
            cell.lbl.backgroundColor = UIColor.lightGray
            cell.lbl.textColor = UIColor.white
        }
        
        
        if let lastselectedIndex = lastSelectedIndexPath {
            if indexPath == lastselectedIndex && todoButtonTapped {
                cell.lbl.backgroundColor = UIColor.clear
                cell.lbl.textColor = UIColor.black
                todoButtonTapped = false
            }
        }
        
        return cell
    }
    
    //콜렉션뷰의 날짜를 선택하면 테이블뷰의 데이터가 변한다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellYear = currentYear
        let cellMonth = currentMonth
        let cellDay = indexPath.row - firstWeekDayOfMonth + 2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        let currentCellDateTime = formatter.date(from: cellDateString)
        
        lastSelectedDate = currentCellDateTime//현재 선택된 셀의 date객체
        lastSelectedIndexPath = indexPath
        
        let userInfo = [ "currentCellDateTime" : currentCellDateTime ]
        
        //CalendarVC에 지금 선택된 날짜를 전송 안해도 되고 변수에 저장해 놓으면 됨
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didselectItem"), object: nil, userInfo: userInfo as [AnyHashable : Any])
        
    }
    
    //새로운 셀 선택시 이전셀 복구
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            return
        }
        
        guard let lbl = cell.subviews.last as? UILabel else {
            return
        }
        
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = Style.activeCellLblColor
        
        if indexPath.row % 7 == 0 { //일요일
            lbl.textColor = UIColor.red
            lbl.backgroundColor = UIColor.clear
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
    }
    
}

//MARK:- CollectionView Layout
extension CalenderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 7.1
        
        var height = collectionView.frame.height / 7.1
        
        if numberOfCurrentMonthDays == 35 {
            height = collectionView.frame.height / 5.1
        } else {
            height = collectionView.frame.height / 6.1
        }
        
        return CGSize(width: width, height: height)
    }
    
    //minimumLineSpacing  (세로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //minimumInteritemSpacing  (가로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}




/*
 func addTestData(eventDictionary: [Int:[event]], indexpath: IndexPath) {
 
 let date1 = "2019-02-11 14:59:59"
 let date2 = "2019-02-11 15:59:59"
 let date3 = "2019-02-11 16:59:59"
 let date4 = "2019-02-11 16:59:59"
 let date5 = "2019-02-11 16:59:59"
 
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
 
 let endDate1 = dateFormatter.date(from: date1)!
 let endDate2 = dateFormatter.date(from: date2)!
 let endDate3 = dateFormatter.date(from: date3)!
 let endDate4 = dateFormatter.date(from: date4)!
 //let endDate5 = dateFormatter.date(from: date4)!
 
 if indexPath.item == 15 {
 eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate1, title: "가가", categoryIdx: 1))
 
 eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate2, title: "니나", categoryIdx: 2))
 
 eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "다다", categoryIdx: 3))
 
 eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "라라", categoryIdx: 3))
 }
 
 eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "마마", categoryIdx: 3))
 }
 */



