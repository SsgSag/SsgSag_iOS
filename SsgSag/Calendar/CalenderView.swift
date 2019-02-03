
import UIKit

class CalenderView: UIView, MonthViewDelegate {
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]//12달
    
    var currentMonth: Int = 0
    
    var currentYear: Int = 0
    
    var presentMonthIndex = 0
    
    var presentYear = 0
    
    var currentDay = 0
    
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7) 일:1,월:2 ~ 금:6,토:7
    
    var reValue = 0
    
    var posterTuples: [(startDate: Date, endDate: Date, dayInterval: Int, categoryIdx: Int, title: String, Int)] = []
    
    var currentPosterTuple:[(Date, Date, Int, Int, String, Int)] = []
    
    var eventDictionary: [Int:[event]] = [:]
    
    var lastSelectedDate: Date?
    
    var lastSelectedIndexPath: IndexPath?
    
    var didDeselctCount = 0
    
    var todaysIndexPath: IndexPath?
    
    struct event {
        let eventDate: Date
        let title: String
        let categoryIdx: Int
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCalenderViewColor()
        setupPosterTuple()
        initMonthAndCalendarCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTodoTableStatusByButton), name: NSNotification.Name("changeTodoTableStatusByButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
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
    
    func setupPosterTuple() {
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
                    
                    if isDuplicatePosterTuple(posterTuples,
                                              input: (posterStartDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0), posterEndDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0),
                                                      dayInterval, poster.categoryIdx!,
                                                      poster.posterName!,
                                                      poster.categoryIdx!)) == false {
                        posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                    }
                }
            }
        }
    }
    
    //마지막 선택된 날짜의 셀의 백그라운드 색깔을 지우자
    //투두리스트를 표현하자
    @objc func changeTodoTableStatusByButton() {
        if let index = lastSelectedIndexPath {
            let cell = collectionView(calendarCollectionView, cellForItemAt: index) as! DayCollectionViewCell
            cell.lbl.backgroundColor = .clear
            cell.lbl.textColor = .black
        }
        calendarCollectionView.reloadData()
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
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
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
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        monthView.delegate = self
        
        //월화수목금토
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(calendarCollectionView)
        calendarCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 15).isActive = true
        calendarCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        calendarCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
        myCollectionView.showsHorizontalScrollIndicator = true
        myCollectionView.isScrollEnabled = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







