
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
    
    var lineTuple = (100,100,100,100)
    
    var posterTuples: [(startDate: Date, endDate: Date, dayInterval: Int, categoryIdx: Int, title: String, Int)] = []
    var currentPosterTuple:[(Date, Date, Int, Int, String, Int)] = []
    var eventDictionary: [Int:[event]] = [:]
    
    struct event {
        let eventDate: Date
        let title: String
        let categoryIdx: Int
    }
    
    var lastSelectedDate: Date?
    var lastSelectedIndexPath: IndexPath?
    
    var didDeselctCount = 0
    
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
            
                    if isDuplicatePosterTuple(posterTuples, input: (posterStartDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0), posterEndDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0), dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!)) == false {
                        posterTuples.append((posterStartDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0), posterEndDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0), dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                        
                        print("qqqq \(poster.posterName) \(posterEndDateTime!.addingTimeInterval(60.0 * 60.0 * 9.0))")
                    }
                }
                
                print()
            }
        }
        
        self.myCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCalenderViewColor()
        
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
                
                    if isDuplicatePosterTuple(posterTuples, input: (posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0)) == false {
                        posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0))
                    }
                }
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundColor), name: NSNotification.Name("changeBackgroundColor"), object: nil)
        //좋아요 선택시 유저티폴츠에 넣고 그것의 반응을 받는다.
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        initializeView()
    }
    
    //마지막 선택된 날짜의 셀의 백그라운드 색깔을 지우자
    //투두리스트를 표현하자
    @objc func changeBackgroundColor() {
        if let index = lastSelectedIndexPath {
            let cell = collectionView(myCollectionView, cellForItemAt: index) as! dateCVCell
            cell.lbl.backgroundColor = .clear
            cell.lbl.textColor = .black
        }
        myCollectionView.reloadData()
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
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        initializeView()
    }
    
    
    private func setCalenderViewColor() {
        myCollectionView.reloadData()
        monthView.monthName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currentDay = Calendar.current.component(.day, from: Date())
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days 4년에 한번씩 2월은 29일
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonth-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonth
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    
  

    var todaysIndexPath: IndexPath?
    

    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    //월이 바뀔때
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonth = monthIndex+1 //월+1
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
        
        self.myCollectionView.reloadData()
        monthView.btnLeft.isEnabled = true
    }
    
    func setupViews() {
        //월
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        //월화수목금토
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 15).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //sectionInset 섹션 내부 여백
        //layout.scrollDirection = .horizontal //이거 이용하면 month 이동시 이전 month 보여지면서 다음 month도 보여지게 할 수 있을듯
        
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

//날짜 하나에 해당하는 셀
class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeToUp), name: NSNotification.Name("changeToUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDown), name: NSNotification.Name("changeToDown"), object: nil)
        
        
        layoutSubviews()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
        
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    @objc func changeToUp() {
        
        self.layoutIfNeeded()
    }
    
    @objc func changeToDown() {
        self.layoutIfNeeded()
    }
    
    func setupDotContentsView(eventNum: Int, categories: [Int]) {
        
        addSubview(dotContentsView)
        
        dotContentsView.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 0.6).isActive = true
        dotContentsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotContentsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        dotContentsView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true


        switch eventNum {
        case 1:
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            
        case 2:
            dotContentsView.dotView2.isHidden = false
             NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.8, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.2, constant: 0).isActive = true
        default:
            break
        }
        NSLayoutConstraint(item: dotContentsView.dotView5, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.12, constant: 0).isActive = true
        

        print("dotView Width: \(dotContentsView.dotView1.frame.width)")
//        dotContentsView.dotView1.circleView()
        
        dotContentsView.layoutSubviews()
        dotContentsView.layoutIfNeeded()
        
    }

    
    func setupDotViews(eventNum: Int, categories: [Int]) {
        addSubview(dotDot)
        
        dotDot.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 0.6).isActive = true
        dotDot.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotDot.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        dotDot.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        switch eventNum {
        case 1:
            
            dotDot.addSubview(dot)
            dot.backgroundColor = .black
            dot.center = dotDot.center
//            dot.topAnchor.constraint(equalTo: dotDot.topAnchor).isActive = true
//            dot.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            dot.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            dot.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
            dot.layer.cornerRadius = dot.frame.width / 2

        case 2:
            dotDot.addSubview(dot)
            dot.backgroundColor = .red
            
            dot.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -3).isActive = true
            dot.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            dot.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.12).isActive = true
            dot.layer.cornerRadius = dot.frame.width / 2
            
            dotDot.addSubview(dot2)
            dot2.backgroundColor = .green
            
            dot2.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 3).isActive = true
            dot2.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            dot2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.12).isActive = true
            dot2.layer.cornerRadius = dot2.frame.width / 2
            
            
        default: break
            
        }
        dotDot.layoutSubviews()
        dotDot.layoutIfNeeded()
    }
    
    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47).isActive = true
        lbl.heightAnchor.constraint(equalTo: lbl.widthAnchor).isActive = true
        
        addSubview(dot)
        dot.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 0.6).isActive = true
        //dot.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //dot.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dot.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dot.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        dot.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        dot.layer.cornerRadius = dot.frame.width / 2
        
   
        dot2.layer.cornerRadius = dot2.frame.width / 2
        
//        dot.addSubview(lineLabel)
//        lineLabel.leftAnchor.constraint(equalTo: line.leftAnchor).isActive = true
//        lineLabel.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
//        lineLabel.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
//        lineLabel.bottomAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
    }
    
    //일
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.layer.cornerRadius = label.frame.height / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    //구분선
    let dot: UIView = {
        let dot = UIView()
        dot.layer.cornerRadius = dot.frame.height / 2
        dot.layer.masksToBounds = true
        dot.translatesAutoresizingMaskIntoConstraints = false
        return dot
    }()
    
    let dot2: UIView = {
        let dot2 = UIView()
        dot2.layer.cornerRadius = dot2.frame.height / 2
        dot2.layer.masksToBounds = true
        dot2.translatesAutoresizingMaskIntoConstraints = false
        return dot2
    }()
    
    let dotDot: DotView = {
        let dt = DotView()
        dt.translatesAutoresizingMaskIntoConstraints = false
        return dt
    }()
    
    let dotContentsView: DotView = {
        let dt = DotView()
        dt.translatesAutoresizingMaskIntoConstraints = false
        return dt
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

//테마 색설정
struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}




