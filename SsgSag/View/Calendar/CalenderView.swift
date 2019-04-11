
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
    
    static var posterTuples: [(startDate: Date, endDate: Date, dayInterval: Int, categoryIdx: Int, title: String, Int)] = []
    
    private var eventDictionary: [Int:[event]] = [:]
    
    private var lastSelectedDate: Date?
    
    private var lastSelectedIndexPath: IndexPath?
    
    private var todaysIndexPath: IndexPath?
    
    private var todoButtonTapped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCalenderViewColor()
        
        setupPosterTuple()
        
        initMonthAndCalendarCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoListButtonAction), name: NSNotification.Name("todoListButtonAction"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteUserDefaults), name: NSNotification.Name(rawValue: "deleteUserDefaults"), object: nil)
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        Style.themeLight()
        initMonthAndCalendarCollectionView()
    }
    
    @objc func addUserDefaults() {
        
        setupPosterTuple()
        
        self.calendarCollectionView.reloadData()
        
    }
    
    private func getPosterUsingUserDefaults() -> [Posters] {
        guard let posterData = UserDefaults.standard.object(forKey: "poster") as? Data else {
            return []
        }
        guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else {
            return []
        }
        return posterInfo
    }
    
    @objc func deleteUserDefaults() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let posterInfo = getPosterUsingUserDefaults()
        
        CalenderView.posterTuples = []
        
        for poster in posterInfo {
            
            let startDate = formatter.date(from: poster.posterStartDate!)
            let endDate = formatter.date(from: poster.posterEndDate!)
            let components = Calendar.current.dateComponents([.day], from: startDate!, to: endDate!)
            let dayInterval = components.day! + 1
            
            CalenderView.posterTuples.append((startDate!,
                                              endDate!,
                                              dayInterval,
                                              poster.categoryIdx!,
                                              poster.posterName!,
                                              poster.categoryIdx!))
        }
        
        self.calendarCollectionView.reloadData()
    }
    
    func setupPosterTuple() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let posterInfo = getPosterUsingUserDefaults()
                for poster in posterInfo {
                    
                    guard let posterStartDate = poster.posterStartDate else {
                        return
                    }
                    
                    guard let posterEndDate = poster.posterEndDate else {
                        return
                    }
                    
//                    guard let componetsDay = components.day else {
//                        return
//                    }
                    
                    let posterStartDateTime = formatter.date(from: posterStartDate)
                    let posterEndDateTime = formatter.date(from: posterEndDate)
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    
                    if isDuplicatePosterTuple(CalenderView.posterTuples,
                                              input: (posterStartDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0),       posterEndDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0),
                                                      dayInterval,
                                                      poster.categoryIdx!,
                                                      poster.posterName!,
                                                      poster.categoryIdx!)) == false {
                        
                        CalenderView.posterTuples.append((posterStartDateTime!,
                                                          posterEndDateTime!,
                                                          dayInterval,
                                                          poster.categoryIdx!,
                                                          poster.posterName!,
                                                          poster.categoryIdx!))
            }
        }
    }
    
    //마지막 선택된 날짜의 셀의 백그라운드 색깔을 지우자
    //투두리스트를 표현하자
    @objc func todoListButtonAction() {
        todoButtonTapped = true
        if let index = lastSelectedIndexPath {
            calendarCollectionView.reloadItems(at: [index])
            //            let cell = collectionView(calendarCollectionView, cellForItemAt: index) as! DayCollectionViewCell
            //            print("cell: \(cell)")
            //            print("indexPath: \(index)")
            //            cell.lbl.backgroundColor = .red
            //            cell.lbl.textColor = .black
            //            cell.layoutIfNeeded()
        }
        //        calendarCollectionView.reloadData()
        
    }
    
    //putDate를 lineArray에 날짜 중복되지 않고 넣을 수 있는가?
    func isGoodTopPut(lineArray:[(Date,Date,Int,Int,String,Int)] , putDate:(Date, Date,Int,Int,String,Int)) -> Bool {
        var count = 0
        for i in lineArray {
            //어레이에 들어있는 모든 원소들이 이제 넣어야할 원소와 하나도 겹치지 않는다면
            if i == putDate {
                return false
            }
            if isDuplicate(startDate: i.0, endDate: i.1, startSecondDate: putDate.0, endSecondDate: putDate.1) == false {
                count += 1
            }else {
                return false
            }
        }
        if count == lineArray.count {
            return true
        }else {
            return false
        }
    }
    
    //안겹치면 false를 리턴
    func isDuplicate(startDate: Date, endDate: Date, startSecondDate: Date, endSecondDate: Date) -> Bool {
        if startDate > endSecondDate {
            return false
        }
        if endDate < startSecondDate {
            return false
        }
        return true
    }
    
    func isDuplicatePosterTuple(_ posterTuples:[(Date, Date, Int, Int, String, Int)], input: (Date, Date, Int, Int, String, Int)) -> Bool {
        for i in posterTuples {
            if i.4 == input.4 {
                return true
            }
        }
        return false
    }
    
    private func setCalenderViewColor() {
        monthView.monthName.textColor = .black
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = .black
            if i == 0 {
                (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = .red
            }
        }
    }
    
    func initMonthAndCalendarCollectionView() {
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currentDay = Calendar.current.component(.day, from: Date())
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //윤년 계산 4년에 한번씩 2월은 29일
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonth-1] = 29
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
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonth = monthIndex + 1 //월+1
        currentYear = year
        //for leap year, make february month of 29 days
        if monthIndex == 1 { //4년에 한번 29일까지
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
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

extension CalenderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //현재달의 표현해야하는 일자의 개수를 return한다.
        if numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1 > 35 {
            numberOfCurrentMonthDays = 42
        }else {
            numberOfCurrentMonthDays = 35
        }
        return numberOfCurrentMonthDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DayCollectionViewCell else {
            return .init()
        }
        
        var beforeMonthIndex = 0
        
        var beforeYear = 0 //이번달의 전 달이 어떤날에 해당하는지 확인!!
        
        var nextYear = 0
        
        var nextMonth = 0
        
        var nextMonthDay = 0
        
        if currentMonth == 1 { //이번달이 1월이면 이전달은 12월
            beforeMonthIndex = 12
            beforeYear = currentYear - 1
        } else {
            beforeMonthIndex = currentMonth - 1
            beforeYear = currentYear
        }
        
        var beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
        
        if beforeMonthIndex == 2 {
            if currentYear % 4 == 0 {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1] + 1
            } else {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
            }
        }
        
        if currentMonth == 12 {
            nextYear = currentYear + 1
            nextMonth = 1
        } else {
            nextYear = currentYear
            nextMonth = currentMonth + 1
        }
        
        let shouldShowBeforeMonthDay = indexPath.item <= firstWeekDayOfMonth - 2
        
        if shouldShowBeforeMonthDay { //이전달의 표현해야 하는 날짜들
            let beforeMonthDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2
            cell.isHidden = false
            cell.lbl.textColor = UIColor.rgb(red: 224, green: 224, blue: 224)
            cell.lbl.text = "\(beforeMonthDay)"
            cell.isUserInteractionEnabled = false
            
        } else { //현재달에 표현해야 하는 날짜들
            
            let shouldShowDay = indexPath.row-firstWeekDayOfMonth+2
            
            cell.isHidden = false
            cell.lbl.text = "\(shouldShowDay)"
            cell.isUserInteractionEnabled = true
            cell.lbl.textColor = Style.activeCellLblColor
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
                cell.isHidden = false
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
        
        for posterTuple in CalenderView.posterTuples {
            //현재 셀의 연, 월 , 일 == tuple의 연 월 일이 모두 같아야만 그려준다.
            if let _ = currentCellDateTime {
                
                let currentPosterYear = Calendar.current.component(.year, from: posterTuple.endDate)
                let currentPosterMonth = Calendar.current.component(.month, from: posterTuple.endDate)
                let currentPosterDay = Calendar.current.component(.day, from: posterTuple.endDate)
                
                //print("그려라라라라 \(currentCellDate) \(posterTuple.categoryIdx)  \(posterTuple.endDate.addingTimeInterval(60.0 * 60.0 * 9.0))")
                //Dictionary에 이벤트 추가
                
                if (cellYear ==  currentPosterYear) &&
                    (cellMonth == currentPosterMonth) &&
                    (cellDay == currentPosterDay) {
                    eventDictionary[indexPath.row]?.append(event.init(eventDate: posterTuple.endDate, title: posterTuple.title, categoryIdx: posterTuple.categoryIdx))
                }
            }
        }
        
        cell.drawDotAndLineView(indexPath, eventDictionary: eventDictionary)
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        
        //다른달에 갔다 올때 마지막 선택된 날짜가 있고 현재 셀이
        if lastSelectedDate != nil &&
            currentDay == cellDay &&
            currentYear == presentYear &&
            currentMonth == presentMonthIndex{
            
            todaysIndexPath = indexPath
            let lbl = cell.subviews[1] as! UILabel
            lbl.layer.cornerRadius = lbl.frame.height / 2
            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            lbl.textColor = UIColor.white
        }
        
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
        
        if indexPath == lastSelectedIndexPath && todoButtonTapped {
            cell.lbl.backgroundColor = UIColor.clear
            cell.lbl.textColor = UIColor.black
            todoButtonTapped = false
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
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDateString: String = "\(year)-\(month)-\(day) 00:00:00"
        let todayDate = formatter.date(from: currentDateString)
        
        if lastSelectedDate == todayDate{ //마지막 선택된 날짜가 오늘이라면
            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            lbl.textColor = UIColor.white
        }
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



