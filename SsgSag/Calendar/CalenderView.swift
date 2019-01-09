//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]//12달
    var currentMonth: Int = 0
    var currentYear: Int = 0
    
    var presentMonthIndex = 0
    var presentYear = 0
    
    var currentDay = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7) 일:1,월:2 ~ 금:6,토:7
    
    var reValue = 0
    
    var lineTuple = (100,100,100,100)
    var lineArray: [(Int,Int,Int,Int)] = []
    
    var posterTuple:[(Date, Date, Int, Int, String, Int)] = []
    
    var lineArray1:[(Date,Date,Int,Int,String,Int)] = []
    var lineArray2:[(Date,Date,Int,Int,String,Int)] = []
    var lineArray3:[(Date,Date,Int,Int,String,Int)] = []
    var lineArray4:[(Date,Date,Int,Int,String,Int)] = []
    
    var currentPosterTuple:[(Date, Date, Int, Int, String, Int)] = []
    
    var lastSelectedDate:Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let defaults = UserDefaults.standard
        //guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        //guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    let posterStartDateTime = formatter.date(from: poster.posterStartDate!)
                    let posterEndDateTime = formatter.date(from: poster.posterEndDate!)
                    
                    let components = Calendar.current.dateComponents([.day], from: posterStartDateTime!, to: posterEndDateTime!)
                    let dayInterval = components.day! + 1
                    posterTuple.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0))
                }
            }
        }
        
        
        let s1 = formatter.date(from: "2019-01-16 15:00:00")
        let e1 = formatter.date(from: "2019-01-17 14:59:00")
        
        let s2 = formatter.date(from: "2019-01-01 08:00:00")
        let e2 = formatter.date(from: "2019-01-12 08:00:00")
        
        let s3 = formatter.date(from: "2019-01-05 08:00:00")
        let e3 = formatter.date(from: "2019-01-18 08:00:00")
        
        let s4 = formatter.date(from: "2019-01-19 15:00:00")
        let e4 = formatter.date(from: "2019-01-31 14:59:59")
        
        let s5 = formatter.date(from: "2019-01-08 15:00:00")
        let e5 = formatter.date(from: "2019-01-09 14:59:59")
        
        let s6 = formatter.date(from: "2019-01-10 15:00:00")
        let e6 = formatter.date(from: "2019-01-11 14:59:59")
        
        let s7 = formatter.date(from: "2019-01-14 15:00:00")
        let e7 = formatter.date(from: "2019-01-17 14:59:59")
        
        let s8 = formatter.date(from: "2019-01-01 15:00:00")
        let e8 = formatter.date(from: "2019-01-07 14:59:59")
        
        let s9 = formatter.date(from: "2019-01-14 15:00:00")
        let e9 = formatter.date(from: "2019-01-18 14:59:59")
        
        let s10 = formatter.date(from: "2019-12-17 15:00:00")
        let e10 = formatter.date(from: "2019-12-31 14:59:59")
        
        let s11 = formatter.date(from: "2018-12-19 15:00:00")
        let e11 = formatter.date(from: "2019-01-03 14:59:59")
        
        posterTuple = [(s1!, e1!, 395, 1, "스마트청춘MD", 0),
            (s2!, e2!, 12, 0, "비즈니스 아이디어 공모전", 0),
            (s3!, e3!, 12, 0, "레진코믹스 세계만화공모전", 0),
            (s4!, e4!, 4, 5, "아주 캐피탈 대학생 봉사단", 0),
            (s5!, e5!, 3, 0, "에스윈아이디어공모전", 0),
            (s6!, e6!, 3, 2, "솝트 동아리", 0),
            (s7!, e7!, 3, 2, "새로운 일정", 0),
            (s8!, e8!, 3, 2, "새로운 일정", 0),
            (s9!, e9!, 3, 2, "새로운 일정2", 0),
            (s10!, e10!, 3, 2, "새로운 일정3", 0),
            (s11!, e11!, 3, 2, "민지 일정", 0),
        ]
         
        
        if posterTuple.count > 0 {
                posterTuple.sort{$0.2 > $1.2}
       
        var countLine = 0
        
        print("123123123123123123123123123123123123")
        
        lineArray1.append(posterTuple[countLine])
        countLine = -1
        for k in 1...posterTuple.count-1 {
            if isGoodTopPut(lineArray: lineArray1, putDate: posterTuple[k]) == true {
                lineArray1.append(posterTuple[k])
            }
        }
        /* 라인 2 */
        var posterTuple2:[(Date,Date,Int,Int,String,Int)] = []
        //라인 2에 들어가는 가장긴 포스터를 찾자.
        for k in 1...posterTuple.count - 1{
            var count1 = 0
            for l in lineArray1 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                posterTuple2.append(posterTuple[k])
            }
            //안포함 했을때만 posterTuple2에 추가
        }
        if posterTuple2.count >= 1 {
            lineArray2.append(posterTuple2[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
            
            countLine = -1
            
            for k in 1...posterTuple2.count-1 {
                if isGoodTopPut(lineArray: lineArray2, putDate: posterTuple2[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                    lineArray2.append(posterTuple2[k])
                }
            }
        }
        /* 라인 3 */
        var posterTuple3:[(Date,Date,Int,Int,String,Int)] = []
        
        //라인 3에 들어가는 가장긴 포스터를 찾자.
        for k in 0...posterTuple.count-1{
            //lineArray1과 lineArray2에 안들어가는 posterTuple의 값들만 posterTuple3에 넣는다.
            var count1 = 0
            for l in lineArray1 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            
            for l in lineArray2 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            
            if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                posterTuple3.append(posterTuple[k])
            }
            //안포함 했을때만 posterTuple2에 추가
        }
        if posterTuple3.count >= 1 {
            lineArray3.append(posterTuple3[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
            
            countLine = -1
            
            for k in 1...posterTuple3.count-1 {
                if isGoodTopPut(lineArray: lineArray3, putDate: posterTuple3[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                    lineArray3.append(posterTuple3[k])
                }
            }
        }
        /* 라인 4 */
        var posterTuple4:[(Date,Date,Int,Int,String,Int)] = []
        //라인 3에 들어가는 가장긴 포스터를 찾자.
        for k in 0...posterTuple.count-1{
            var count1 = 0
            for l in lineArray1 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            for l in lineArray2 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            for l in lineArray3 {
                if l == posterTuple[k] {
                    count1 += 1
                }
            }
            if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                posterTuple4.append(posterTuple[k])
            }
        }
        
        if posterTuple4.count >= 1 {
            lineArray4.append(posterTuple4[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
            
            countLine = -1
            for k in 0...posterTuple4.count-1 {
                if isGoodTopPut(lineArray: lineArray4, putDate: posterTuple4[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                    lineArray4.append(posterTuple4[k])
                }
            }
        }
            print(lineArray1)
            
            
            print(lineArray2)
            
            
            print(lineArray3)
            
            
            print(lineArray4)
            
        }//posterTuple.count 처리

        
        initializeView()
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
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        initializeView()
    }

    
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
    
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reValue = 0
        if numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1 > 35 {
            reValue = 42
        }else {
            reValue = 35
        }
        lineArray = []
        for _ in 0..<reValue {
            lineArray.append(lineTuple)
        }
        return reValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        
        cell.lbl.backgroundColor = .clear
        cell.lbl.layer.cornerRadius = cell.lbl.frame.height / 2
        cell.line.backgroundColor = .clear
        cell.line2.backgroundColor = .clear
        cell.line3.backgroundColor = .clear
        cell.line4.backgroundColor = .clear
        
        var beforeMonthIndex = 0
        var beforeYear = 0 //이번달의 전 달이 어떤날에 해당하는지 확인!!
        
        if currentMonth == 1 { //이번달이 1월이면 이전달은 12월
            beforeMonthIndex = 12
            beforeYear = currentYear - 1
        }else {
            beforeMonthIndex = currentMonth - 1
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
        
        if currentMonth == 12 {
            nextYear = currentYear + 1
            nextMonth = 1
        }else {
            nextYear = currentYear
            nextMonth = currentMonth + 1
        }
        var nextDay = 0
        
        if indexPath.item <= firstWeekDayOfMonth - 2 { //이전달의 표현해야 하는 날짜들
            cell.isHidden=false
            cell.lbl.textColor = .lightGray
            cell.lbl.text = "\(beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2)"
            if currentDay == beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2 {
                
            }
            cell.isUserInteractionEnabled=false
        } else { //오늘 이후 날짜
            let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = Style.activeCellLblColor
            cell.lbl.backgroundColor = .clear
            
            if calcDate == currentDay && currentYear == presentYear && currentMonth == presentMonthIndex { //오늘날짜
                todaysIndexPath = indexPath
                let lbl = cell.subviews[1] as! UILabel
                lbl.layer.cornerRadius = (cell.frame.width * 0.47) / 2
                print("asdgasdg \(cell.frame.height)")
                lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
                lbl.textColor=UIColor.white
            }
            if indexPath.row % 7 == 0 {
                cell.lbl.textColor = .red
            }
            nextDay = (calcDate + firstWeekDayOfMonth - 1) - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1)
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
        
        //cell.layer.cornerRadius = 0
        
        /*   임의의 데이터
            let startYear = 2018
            let startMonth = 12
            let startDay = 26
        */
        
        var cellYear = currentYear
        var cellMonth = currentMonth
        var cellDay = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 22:31:11"
        var currentCellDateTime = formatter.date(from: cellDateString)
        
        if lastSelectedDate != nil && lastSelectedDate == currentCellDateTime {
            cell.lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            cell.lbl.textColor=UIColor.white
            //오늘 날짜에 해당하는 셀을 회색으로 바꾼다.
        }
        //마지막으로 선택된 날이 있고 현재 셀이 오늘날짜라면
         let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
        if lastSelectedDate != nil && calcDate == currentDay && currentYear == presentYear && currentMonth == presentMonthIndex{
            todaysIndexPath = indexPath
            let lbl = cell.subviews[1] as! UILabel
            lbl.layer.cornerRadius = (cell.frame.width * 0.47) / 2
            print("asdgasdg \(cell.frame.height)")
            lbl.backgroundColor = .lightGray
            lbl.textColor=UIColor.white
        }
        
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
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        cell.line.backgroundColor = .clear
        cell.line2.backgroundColor = .clear
        cell.line3.backgroundColor = .clear
        cell.line4.backgroundColor = .clear
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        let currentDateString: String = "\(year)-\(month)-\(day) 22:31:11"
        let todayDate = formatter.date(from: currentDateString)
        
        //라인 내부에 글자 표현
        for line1 in lineArray1 {
            if line1.0 <= currentCellDateTime! && currentCellDateTime! <= line1.1{ //
                cell.line.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.462745098, blue: 0.8666666667, alpha: 1)
                if currentCellDateTime! < todayDate! {
                    cell.line.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
                
                if cell.line.subviews.count > 0 {
                    let label = cell.line.subviews[0] as! UILabel
                    label.text = ""
                }
                
                let line1Componets = calendar.dateComponents([.year, .month, .day], from: line1.0)
                let currentComponets = calendar.dateComponents([.year, .month, .day], from: currentCellDateTime!)
                
                let yearline1Componets = line1Componets.year!
                let monthline1Componets = line1Componets.month!
                let dayline1Componets = line1Componets.day!

                let yearcurrentComponets = currentComponets.year!
                let monthcurrentComponets = currentComponets.month!
                let daycurrentComponets = currentComponets.day!

                if yearline1Componets == yearcurrentComponets && monthline1Componets == monthcurrentComponets && dayline1Componets == daycurrentComponets {
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.line.frame.width, height: cell.line.frame.height))
                    label.textAlignment = .left
                    label.font = UIFont.systemFont(ofSize: 6.0)
                    label.text = line1.4
                    cell.line.addSubview(label)
                }
            }
        }
        
        for line2 in lineArray2 {
            if line2.0 <= currentCellDateTime! && currentCellDateTime! <= line2.1 {
                cell.line2.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.6509803922, blue: 1, alpha: 1)
                if currentCellDateTime! < todayDate! {
                    cell.line2.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
            
        }
        
        for line3 in lineArray3 {
            if line3.0 <= currentCellDateTime! && currentCellDateTime! <= line3.1 {
                cell.line3.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
                if currentCellDateTime! < todayDate! {
                    cell.line3.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
            
        }
        
        for line4 in lineArray4 {
            if line4.0 <= currentCellDateTime! && currentCellDateTime! <= line4.1 {
                cell.line4.backgroundColor = #colorLiteral(red: 1, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
                if currentCellDateTime! < todayDate! {
                    cell.line4.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
        }
        
        //cell.lbl.layer.cornerRadius = cell.lbl.frame.height / 2
        //cell.lbl.backgroundColor = .yellow
        currentPosterTuple = []
        
        return cell
    }
    
    var todaysIndexPath: IndexPath?
    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell=collectionView.cellForItem(at: indexPath)
        let lbl = cell?.subviews[1] as! UILabel
        lbl.layer.cornerRadius = lbl.frame.height / 2
        lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
        lbl.textColor=UIColor.white
        
        var currentSelectedYear = currentYear
        var currentSelectedMonth = currentMonth
        var currentSelectedDay = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var currentSelectedDateString = "\(currentSelectedYear)-\(currentSelectedMonth)-\(currentSelectedDay) 22:31:11"
        var currentSelectedDate = formatter.date(from: currentSelectedDateString)
        
        
        if didDeselctCount == 0{
            let todaysCell = collectionView.cellForItem(at: todaysIndexPath!) //오늘 indexpath
            let todaylbl = todaysCell?.subviews[1] as! UILabel
            todaylbl.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            todaylbl.textColor=UIColor.white
        }
        didDeselctCount += 1
        
        lastSelectedDate = currentSelectedDate//현재 선택된 셀의 date객체
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoUp"), object: nil)
    }
    
    var didDeselctCount = 0
    //새로운 셀 선택시 이전셀 복구
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell=collectionView.cellForItem(at: indexPath) as! dateCVCell
        let lbl = cell.subviews[1] as! UILabel
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = Style.activeCellLblColor

        if indexPath.row % 7 == 0 { //일요일
            lbl.textColor = UIColor.red
            lbl.backgroundColor = UIColor.clear
        }
        
        //indexPath 로만 비교하지 말고
//        if todaysIndexPath == indexPath && {
//            lbl.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//            lbl.textColor = UIColor.white
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
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
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    //월이 바뀔때
    func didChangeMonth(monthIndex: Int, year: Int) {
        
        print("\(lastSelectedDate) 마지막으로 선택된 날짜")
        
        currentMonth=monthIndex+1 //월+1
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
        
        //여기서 확대 해야지!!!!!!!!!!!!!!!
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeToUp), name: NSNotification.Name("changeToUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDown), name: NSNotification.Name("changeToDown"), object: nil)
        
        setupViews()
    }
    
    var heightlabelAnchor: NSLayoutConstraint?
    var heightlineAnchor: NSLayoutConstraint?
    var heightline2Anchor: NSLayoutConstraint?
    var heightline3Anchor: NSLayoutConstraint?
    var heightline4Anchor: NSLayoutConstraint?
    
    @objc func changeToUp() {

        self.layoutIfNeeded()
    }
    
    @objc func changeToDown() {
        self.layoutIfNeeded()
    }

    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47).isActive = true
        lbl.heightAnchor.constraint(equalTo: lbl.widthAnchor).isActive = true
        
        addSubview(line)
        line.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 0.6).isActive = true
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
        
        addSubview(line2)
        line2.topAnchor.constraint(equalTo: line.bottomAnchor , constant: 0.6).isActive = true
        line2.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
        
        addSubview(line3)
        line3.topAnchor.constraint(equalTo: line2.bottomAnchor , constant: 0.6).isActive = true
        line3.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line3.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
        
        addSubview(line4)
        line4.topAnchor.constraint(equalTo: line3.bottomAnchor , constant: 0.6).isActive = true
        line4.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line4.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line4.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
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
    
    //구분선
    let line4: UIView = {
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








