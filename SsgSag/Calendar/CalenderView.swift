//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

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

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {

    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]//12달
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    
    var presentMonthIndex = 0
    var presentYear = 0
    
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7) 일:1,월:2 ~ 금:6,토:7
    
    var currentBeforeMonthIndex: Int = 0
    var currentBeforeYear: Int = 0
    var currentBeforefirstWeekDayOfMeonth = 0
    
    var reValue = 0
    
    var allPoster:[Posters] = []
    
    
    
    
    //각 셀의 라인 4개를 표현하기 위함
    var lineOfCell1 = 0
    var lineOfCell2 = 0
    var lineOfCell3 = 0
    var lineOfCell4 = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let defaults = UserDefaults.standard
        guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        guard let posterInfo2 = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        allPoster = posterInfo2
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        initializeView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(downSwipeAction), name: NSNotification.Name(rawValue: "downSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upSwipe), name: NSNotification.Name("upSwipe"), object: nil)
    }
    
    @objc func downSwipeAction() {
        
    }
    
    @objc func upSwipe() {
        
    }
    
    //month 바꿀시 눌린 상태복귀
    func changeTheme() {
        myCollectionView.reloadData()
        monthView.monthName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    func initializeView() {
        //오늘
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days 4년에 한번씩 2월은 29일
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        
        setupCalendarDate()
        
        //collectionview의 delegate를 현재 CalendarView로 지정
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
        
        
        
    }
    
    
    func setupCalendarDate() {
        
        let startString = "2019-01-03 00:00:00"
        let lastString = "2018-01-07 00:00:00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let startdate = dateFormatter.date(from: startString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        guard let enddate = dateFormatter.date(from: lastString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        print("가나다라마바사 \(startdate) \(enddate)")
        
        let startYear = startString.components(separatedBy: "-")
        
        
        let fullName    = "First Last"
        let fullNameArr = fullName.components(separatedBy: " ")
        
        let name    = fullNameArr[0]
        let surname = fullNameArr[1]
        
    }
    
    //해당 월에 존재하는 cell의 개수 (12월에 31개의 셀)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("numberofItemsInSection \(numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1)")
//        print("section \(section)")
        
        reValue = 0
        if numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1 > 35 {
            reValue = 42
        }else {
            reValue = 35
        }
        return reValue
        //여기에 다음달의 개수도 더해야 한다.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        
        cell.line.backgroundColor = .clear
        
        var beforeMonthIndex = 0
        var beforeYear = 0 //이번달의 전 달이 어떤날에 해당하는지 확인!!
        
        if currentMonthIndex == 1 { //이번달이 1월이면 이전달은 12월
            beforeMonthIndex = 12
            beforeYear = currentYear - 1
        }else {
            beforeMonthIndex = currentMonthIndex - 1
            beforeYear = currentYear
        }
        
        var beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
        if beforeMonthIndex == 2{
            if currentYear % 4 == 0 {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1] + 1
            }else {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
            }
        }
        
        var nextYear = 0
        var nextMonth = 0
        
        if currentMonthIndex == 12 {
            nextYear = currentYear + 1
            nextMonth = 1
        }else {
            nextYear = currentYear
            nextMonth = currentMonthIndex + 1
        }
        var nextDay = 0
        
        if indexPath.item <= firstWeekDayOfMonth - 2 { //이전달의 표현해야 하는 날짜들
            //달력 실제 달력이랑 같은지 확인 해야함
            cell.isHidden=false
            //cell.line.backgroundColor = UIColor.clear
            cell.lbl.textColor = .lightGray
            cell.lbl.text = "\(beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2)"
            
            //cell.line.backgroundColor = .brown
            
            //이전달의 날짜를 표시할때 오늘 날짜가 포함 되어 있다면
            if todaysDate == beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2 {
                //cell.lbl.backgroundColor = .red
                print("todaysDate : \(todaysDate)")
            }
            cell.isUserInteractionEnabled=false
            
        } else { //오늘 이후 날짜
            //print(numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1)
            let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = Style.activeCellLblColor
            //cell.line.backgroundColor = .green
            cell.lbl.backgroundColor = .clear
            
            if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 날짜
                let lbl = cell.subviews[1] as! UILabel
                lbl.layer.cornerRadius = 10
                lbl.layer.masksToBounds = true
                //cell.line.backgroundColor = .black
                    
                print("블루로 할때 날짜 \(calcDate)")
            }
            
            if indexPath.row % 7 == 0 {
                cell.lbl.textColor = .red
            }
        
            nextDay = (calcDate + firstWeekDayOfMonth - 1) - (numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1)
            //다음달 일수 출력
            if nextDay >= 1 {
                let calcDate = nextDay
                cell.isHidden=false
                cell.lbl.text="\(calcDate)"
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = .lightGray
                //cell.line.backgroundColor = .blue
            }
        }
        cell.layer.cornerRadius = 0
        
        /*   임의의 데이터     */
        let startYear = 2018
        let startMonth = 12
        let startDay = 26
        
        let endYear = 2019
        let endMonth = 2
        let endDay = 3
        /*        */
        /*   임의의 데이터     */
        let startYear2 = 2019
        let startMonth2 = 1
        let startDay2 = 10
        
        let endYear2 = 2019
        let endMonth2 = 1
        let endDay2 = 18
        /*        */
        /*   임의의 데이터     */
        let startYear3 = 2019
        let startMonth3 = 1
        let startDay3 = 1
        
        let endYear3 = 2019
        let endMonth3 = 1
        let endDay3 = 14
        /*        */
        
        
        
        var cellYear = currentYear
        var cellMonth = currentMonthIndex
        var cellDay = indexPath.row-firstWeekDayOfMonth+2
        
        var cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 22:31:11"
        //let startDateString = "\(startYear)/\(startMonth)/\(startDay) 22:31"
        //let endDateString = "\(endYear)/\(endMonth)/\(endDay) 22:31"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var currentCellDateTime = formatter.date(from: cellDateString)
//        let startDateTime = formatter.date(from: startDateString)
//        let endDateTime = formatter.date(from: endDateString)
        
        
        var posterStartDateTime:Date?
        var posterEndDateTime:Date?
        
        cell.line.backgroundColor = .clear
        cell.line2.backgroundColor = .clear
        cell.line3.backgroundColor = .clear
        
        if currentCellDateTime == nil {
            //전달이면
            if indexPath.row < 15 {
                cellYear = beforeYear
                cellMonth = beforeMonthIndex
                cellDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 22:31:11"
                currentCellDateTime = formatter.date(from: cellDateString)
            }else {
                cellYear = nextYear
                cellMonth = nextMonth
                cellDay = nextDay
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 22:31:11"
                currentCellDateTime = formatter.date(from: cellDateString)
            }
        }
        
        print("포스터의 총 개수 \(allPoster.count)")
        for poster in allPoster {
            let posterStartDateString = poster.posterStartDate
            let posterEndDateString = poster.posterEndDate
            
            posterStartDateTime = formatter.date(from: poster.posterStartDate!)
            posterEndDateTime = formatter.date(from: poster.posterEndDate!)
            
//            print("가나다라마마사아자차카타타파하 세종대왕만세")
//            print(posterStartDateString)
//            print(posterStartDateTime)
//            print(posterEndDateString)
//            print(posterEndDateTime)
//            print(currentCellDateTime)
            
            if currentCellDateTime != nil {
                if posterStartDateTime! <= currentCellDateTime! && currentCellDateTime! <= posterEndDateTime! {
                    cell.line.backgroundColor = .red
                }
                
            }
        }
    
        //let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
        //let countOfNextMonthday = (calcDate + firstWeekDayOfMonth - 1) - (numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1)

        /*                    */
        return cell
    }
    
//    func expressCellView(){
//
//    }
    
    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath2 = IndexPath(row: todaysDate, section: 0)
        //오늘 날짜 선택시 색깔 그대로
        if indexPath.row - 5 == indexPath2.row &&  currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 날짜
            
        }else {
            let cell=collectionView.cellForItem(at: indexPath)
            //cell?.backgroundColor=Colors.darkRed
            let lbl = cell?.subviews[1] as! UILabel
            lbl.backgroundColor = Colors.darkRed
            lbl.textColor=UIColor.white
        }
    }
    //새로운 셀 선택시 이전셀 복구
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let indexPath2 = IndexPath(row: todaysDate, section: 0)
        if indexPath.row - 5 == indexPath2.row && currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 날짜 선택시 색깔 그대로
        }else {
            let cell=collectionView.cellForItem(at: indexPath)
            //print("사라질때 indexPath \(indexPath.row)")
            //cell?.backgroundColor=UIColor.clear
            let lbl = cell?.subviews[1] as! UILabel
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = Style.activeCellLblColor
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = collectionView.frame.width / 7 //원래는 /7
        var height = collectionView.frame.height / 7
        
        if reValue == 35 {
            height = collectionView.frame.height / 5
        }else {
            height = collectionView.frame.height / 6
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
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    //월이 바뀔때
    func didChangeMonth(monthIndex: Int, year: Int) {
        
        currentMonthIndex=monthIndex+1 //월+1
        currentYear = year
        //for leap year, make february month of 29 days
        if monthIndex == 1 { //4년에 한번 29일까지
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        firstWeekDayOfMonth=getFirstWeekDay()
        //애니메이션
        self.myCollectionView.reloadData()
        monthView.btnLeft.isEnabled = true
    }
    
    func setupViews() {
        //월
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        //월화수목금토
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        //myCollectionView.backgroundColor = .red
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 15).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
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
        setupViews()
    }

    
    @objc func changeToUp() {
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        line.topAnchor.constraint(equalTo: lbl.bottomAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    @objc func changeToDown() {
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=false
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=false
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=false
        lbl.heightAnchor.constraint(equalToConstant: 15).isActive = false
        
        line.topAnchor.constraint(equalTo: lbl.bottomAnchor).isActive = false
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = false
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = false
        line.heightAnchor.constraint(equalToConstant: 4).isActive = false

        self.layoutIfNeeded()
    }

    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.heightAnchor.constraint(equalToConstant: 14).isActive = true
        //lbl.backgroundColor = .brown
        
        addSubview(line)
        //line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 10).isActive = true
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        addSubview(line2)
        //line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line2.topAnchor.constraint(equalTo: line.bottomAnchor , constant: 2).isActive = true
        line2.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        addSubview(line3)
        //line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line3.topAnchor.constraint(equalTo: line2.bottomAnchor , constant: 2).isActive = true
        line3.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line3.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line3.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    //일
    let lbl: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .yellow
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        //label.backgroundColor = UIColor.red
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    //구분선
    let line: UIView = {
        let line = UIView()
        line.layer.cornerRadius = 0
        line.layer.masksToBounds = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    //구분선
    let line2: UIView = {
        let line = UIView()
        line.layer.cornerRadius = 0
        line.layer.masksToBounds = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    //구분선
    let line3: UIView = {
        let line = UIView()
        //line.backgroundColor = .brown
        line.layer.cornerRadius = 0
        line.layer.masksToBounds = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//날짜 포맷
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













