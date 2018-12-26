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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
    }

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    var statusSize = 1
    
    @objc func downSwipeAction() {
        statusSize = -1
    }
    
    @objc func upSwipe() {
        statusSize = 1
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
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        
        print("이번달:\(currentMonthIndex)")
        currentYear = Calendar.current.component(.year, from: Date())
        print("이번년도:\(currentYear)")
        todaysDate = Calendar.current.component(.day, from: Date())
        print("오늘:\(todaysDate)")
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days 4년에 한번씩 2월은 29일
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        //collectionview의 delegate를 현재 CalendarView로 지정
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //해당 월에 존재하는 cell의 개수 (12월에 31개의 셀)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberofItemsInSection \(numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1)")
        print("section \(section)")
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        
        if indexPath.item <= firstWeekDayOfMonth - 2 { //오늘 날짜가 -1 이하일때 (예외처리)
            cell.isHidden=false
            let calcDate = indexPath.row
            cell.lbl.textColor = .lightGray
            cell.lbl.text = "수정중"
            
        } else { //정상 날짜
            let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
            print("\(calcDate) | \(firstWeekDayOfMonth)")
            
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 이전 날짜
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
                cell.lbl.backgroundColor = .clear
            } else { //오늘 이후 날짜
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
                cell.lbl.backgroundColor = .clear
            }
            if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 날짜
                //cell.backgroundColor = UIColor.brown
                let lbl = cell.subviews[1] as! UILabel
                //label.backgroundColor = UIColor.red
                lbl.layer.cornerRadius = 20
                lbl.layer.masksToBounds = true
                lbl.backgroundColor = .brown
                lbl.textColor = UIColor.white
            }
        }
        return cell
    }
    
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
            print("선택된 날짜 : \(lbl.text)")
            lbl.textColor=UIColor.white
            
        }
    }
    
    //새로운 셀 선택시 이전셀 복구
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let indexPath2 = IndexPath(row: todaysDate, section: 0)
        if indexPath.row - 5 == indexPath2.row && currentYear == presentYear && currentMonthIndex == presentMonthIndex { //오늘 날짜 선택시 색깔 그대로
            
        }else {
            let cell=collectionView.cellForItem(at: indexPath)
            print("사라질때 indexPath \(indexPath.row)")
            //cell?.backgroundColor=UIColor.clear
            let lbl = cell?.subviews[1] as! UILabel
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = Style.activeCellLblColor
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat?
        var height: CGFloat?
        
        width = collectionView.frame.width/7 - 8 //원래는 /7
        
        if statusSize == 1 {
            UIView.transition(with: myCollectionView, duration: 0.5, options: .allowAnimatedContent, animations: {
                height = 60
            }, completion: nil)
            
        }else {
            UIView.transition(with: myCollectionView, duration: 0.5, options: .allowAnimatedContent, animations: {
                height = 100
            }, completion: nil)
        }
        
        return CGSize(width: width!, height: height!)
    }
    
    //minimumLineSpacing  (세로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    //minimumInteritemSpacing  (가로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
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
        
        //이동시 애니메이션
        UIView.transition(with: myCollectionView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            //Do the data reload here
            self.myCollectionView.reloadData()
            //self.myCollectionView.isHidden = false
        }, completion: nil)
        
        monthView.btnLeft.isEnabled = true
        //!(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
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
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }

    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //셀 내부의 라벨이 차지하는 부분, 위로 올려서 밑에 정보를 표시하기 위함
        //lbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive=true
        
//        addSubview(info)
//        info.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant:3).isActive = true
//        info.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        info.widthAnchor.constraint(equalToConstant: 7).isActive = true
//        info.heightAnchor.constraint(equalToConstant: 7).isActive = true
//
//        addSubview(info2)
//        info2.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant:3).isActive = true
//        info2.leftAnchor.constraint(equalTo: info.rightAnchor , constant: 3).isActive = true
//        info2.widthAnchor.constraint(equalToConstant: 7).isActive = true
//        info2.heightAnchor.constraint(equalToConstant: 7).isActive = true
//
//        addSubview(info3)
//        info3.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant:3).isActive = true
//        info3.leftAnchor.constraint(equalTo: info2.rightAnchor , constant: 3).isActive = true
//        info3.widthAnchor.constraint(equalToConstant: 7).isActive = true
//        info3.heightAnchor.constraint(equalToConstant: 7).isActive = true
//
//        addSubview(line)
//        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    //일
    let lbl: UILabel = {
        let label = UILabel()
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
    //해당 날짜에 이벤트가 있을때 추가
    let info: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //해당 날짜에 이벤트가 있을때 추가
    let info2: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //해당 날짜에 이벤트가 있을때 추가
    let info3: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //구분선
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
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













