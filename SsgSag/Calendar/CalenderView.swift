
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
    
    var posterTuples: [(Date, Date, Int, Int, String, Int)] = []
    
    var lineArray1: [(Date,Date,Int,Int,String,Int)] = []
    var lineArray2: [(Date,Date,Int,Int,String,Int)] = []
    var lineArray3: [(Date,Date,Int,Int,String,Int)] = []
    var lineArray4: [(Date,Date,Int,Int,String,Int)] = []
    var lineArray5: [(Date,Date,Int,Int,String,Int)] = []
    
    var currentPosterTuple:[(Date, Date, Int, Int, String, Int)] = []
    
    var lastSelectedDate: Date?
    var lastSelectedIndexPath: IndexPath?
    
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
                    posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, poster.categoryIdx!))
                }
            }
        }
        
        if posterTuples.count == 1 {
            lineArray1.append(posterTuples[0])
        }
        
        if posterTuples.count > 1 {
            posterTuples.sort{$0.2 > $1.2}
            
            var countLine = 0
            lineArray1.append(posterTuples[countLine])
            countLine = -1
            /* 라인 1 */
            for k in 0...posterTuples.count-1 {
                if isGoodTopPut(lineArray: lineArray1, putDate: posterTuples[k]) == true {
                    lineArray1.append(posterTuples[k])
                }
            }
            
            print("라인 1 통과")
            /* 라인 2 */
            var posterTuple2: [(Date,Date,Int,Int,String,Int)] = []
            //라인 2에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count - 1{
                var count1 = 0
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple2.append(posterTuples[k])
                }
                //안포함 했을때만 posterTuple2에 추가
            }
            if posterTuple2.count >= 1 {
                lineArray2.append(posterTuple2[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                
                countLine = -1
                
                for k in 0...posterTuple2.count-1 {
                    if isGoodTopPut(lineArray: lineArray2, putDate: posterTuple2[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray2.append(posterTuple2[k])
                    }
                }
            }
            
            print("라인 2 통과")
            /* 라인 3 */
            var posterTuple3:[(Date,Date,Int,Int,String,Int)] = []
            
            //라인 3에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count-1{
                //lineArray1과 lineArray2에 안들어가는 posterTuple의 값들만 posterTuple3에 넣는다.
                var count1 = 0
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray2 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple3.append(posterTuples[k])
                }
                //안포함 했을때만 posterTuple2에 추가
            }
            if posterTuple3.count >= 1 {
                lineArray3.append(posterTuple3[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                countLine = -1
                
                for k in 0...posterTuple3.count-1 {
                    if isGoodTopPut(lineArray: lineArray3, putDate: posterTuple3[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray3.append(posterTuple3[k])
                    }
                }
            }
            
            print("라인 3 통과")
            /* 라인 4 */
            
            var posterTuple4:[(Date,Date,Int,Int,String,Int)] = []
            //라인 3에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count-1{
                var count1 = 0
                
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray2 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray3 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple4.append(posterTuples[k])
                }
            }
            print("라인 4 통과")
            
            if posterTuple4.count >= 1 {
                lineArray4.append(posterTuple4[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                
                countLine = -1
                for k in 0...posterTuple4.count-1 {
                    if isGoodTopPut(lineArray: lineArray4, putDate: posterTuple4[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray4.append(posterTuple4[k])
                    }
                }
            }
        }//posterTuple.count 처리
        self.myCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
                    
                    posterTuples.append((posterStartDateTime!, posterEndDateTime!, dayInterval, poster.categoryIdx!, poster.posterName!, 0))
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundColor), name: NSNotification.Name("changeBackgroundColor"), object: nil)
        
        //좋아요 선택시 유저티폴츠에 넣고 그것의 반응을 받는다.
        NotificationCenter.default.addObserver(self, selector: #selector(addUserDefaults), name: NSNotification.Name("addUserDefaults"), object: nil)
        
        if posterTuples.count == 1 {
            lineArray1.append(posterTuples[0])
        }
        
        if posterTuples.count > 1 {
            posterTuples.sort{$0.2 > $1.2}
            
            var countLine = 0
            
            lineArray1.append(posterTuples[countLine])
            countLine = -1
            /* 라인 1 */
            for k in 0...posterTuples.count-1 {
                if isGoodTopPut(lineArray: lineArray1, putDate: posterTuples[k]) == true {
                    lineArray1.append(posterTuples[k])
                }
            }
            print("라인 1 통과")
            /* 라인 2 */
            var posterTuple2:[(Date,Date,Int,Int,String,Int)] = []
            //라인 2에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count - 1{
                var count1 = 0
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple2.append(posterTuples[k])
                }
                //안포함 했을때만 posterTuple2에 추가
            }
            if posterTuple2.count >= 1 {
                lineArray2.append(posterTuple2[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                
                countLine = -1
                
                for k in 0...posterTuple2.count-1 {
                    if isGoodTopPut(lineArray: lineArray2, putDate: posterTuple2[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray2.append(posterTuple2[k])
                    }
                }
            }
            print("라인 2 통과")
            /* 라인 3 */
            var posterTuple3:[(Date,Date,Int,Int,String,Int)] = []
            
            //라인 3에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count-1{
                //lineArray1과 lineArray2에 안들어가는 posterTuple의 값들만 posterTuple3에 넣는다.
                var count1 = 0
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray2 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple3.append(posterTuples[k])
                }
                //안포함 했을때만 posterTuple2에 추가
            }
            if posterTuple3.count >= 1 {
                lineArray3.append(posterTuple3[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                countLine = -1
                
                for k in 0...posterTuple3.count-1 {
                    if isGoodTopPut(lineArray: lineArray3, putDate: posterTuple3[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray3.append(posterTuple3[k])
                    }
                }
            }
            print("라인 3 통과")
            /* 라인 4 */
            
            var posterTuple4:[(Date,Date,Int,Int,String,Int)] = []
            //라인 3에 들어가는 가장긴 포스터를 찾자.
            for k in 0...posterTuples.count-1{
                var count1 = 0
                
                for l in lineArray1 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray2 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                for l in lineArray3 {
                    if l == posterTuples[k] {
                        count1 += 1
                    }
                }
                
                if count1 == 0 {//겹치는게 없을때만 posterTUple2에 저장
                    posterTuple4.append(posterTuples[k])
                }
            }
            print("라인 4 통과")
            
            if posterTuple4.count >= 1 {
                lineArray4.append(posterTuple4[0])//posterTuple3에서 가장긴것은 무조건 넣는다.
                
                countLine = -1
                for k in 0...posterTuple4.count-1 {
                    if isGoodTopPut(lineArray: lineArray4, putDate: posterTuple4[k]) == true { //posterTuple2에서 lineArray2에 중복되지 않는 값들을 넣는다.
                        lineArray4.append(posterTuple4[k])
                    }
                }
            }
        }
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
        
        var cellYear = currentYear
        var cellMonth = currentMonth
        var cellDay = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        var currentCellDateTime = formatter.date(from: cellDateString)
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
        //다른달에 갔다 올때 오늘 날짜의 색
        if lastSelectedDate != nil && calcDate == currentDay && currentYear == presentYear && currentMonth == presentMonthIndex{
            todaysIndexPath = indexPath
            let lbl = cell.subviews[1] as! UILabel
            lbl.layer.cornerRadius = (cell.frame.width * 0.47) / 2
            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            lbl.textColor=UIColor.white
        }
        
        if currentCellDateTime == nil {
            //전달이면
            if indexPath.row < 15 {
                cellYear = beforeYear
                cellMonth = beforeMonthIndex
                cellDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
                currentCellDateTime = formatter.date(from: cellDateString)
            }else {
                cellYear = nextYear
                cellMonth = nextMonth
                cellDay = nextDay
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
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
        
        let currentDateString: String = "\(year)-\(month)-\(day) 00:00:00"
        let todayDate = formatter.date(from: currentDateString)
        
        //라인 내부에 글자 표현
        for line1 in lineArray1 {
            if line1.0 <= currentCellDateTime! && currentCellDateTime! <= line1.1{ //
                cell.line.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.462745098, blue: 0.8666666667, alpha: 1)
                
                //라인1의 끝날짜 처리
                let currentCellDateTimeYear = Calendar.current.component(.year, from: currentCellDateTime!)
                let currentCellDateTimeMonth = Calendar.current.component(.month, from: currentCellDateTime!)
                let currentCellDateTimeDay = Calendar.current.component(.day, from: currentCellDateTime!)
                
                //마지막 날짜 체크
                let lineYear = Calendar.current.component(.year, from: line1.1)
                let lineMonth = Calendar.current.component(.month, from: line1.1)
                let lineDay = Calendar.current.component(.day, from: line1.1)
                
                let lineYearStart = Calendar.current.component(.year, from: line1.0)
                let lineMonthStart = Calendar.current.component(.month, from: line1.0)
                let lineDayStart = Calendar.current.component(.day, from: line1.0)
                
                //print("마지막 날짜 체크 \(lineYear) \(lineMonth) \(lineDay)")
                //print("처음 날짜 체크 \(lineYearStart) \(lineMonthStart) \(lineDayStart)")
                
                //현재 검사하는 셀이
                
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
                //
                //                let yearcurrentComponets = currentComponets.year!
                //                let monthcurrentComponets = currentComponets.month!
                //                let daycurrentComponets = currentComponets.day!
                
                
                //마지막 날짜
                if lineYear == currentCellDateTimeYear && lineMonth == currentCellDateTimeMonth && lineDay == currentCellDateTimeDay {
                    cell.line.clipsToBounds = true
                    cell.line.layer.cornerRadius = 4
                    cell.line.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                }
                
                //시작 날짜
                if lineYearStart == currentCellDateTimeYear && lineMonthStart == currentCellDateTimeMonth && (lineDayStart+1) == currentCellDateTimeDay {
                    //print("시작날짜")
                    print(lineDayStart)
                    cell.line.clipsToBounds = true
                    cell.line.layer.cornerRadius = 4
                    cell.line.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                }
                
            }
        }
        //
        
        
        //라인 2
        for line2 in lineArray2 {
            if line2.0 <= currentCellDateTime! && currentCellDateTime! <= line2.1 {
                cell.line2.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.6509803922, blue: 1, alpha: 1)
                
                //line2의 끝날짜 처리
                let currentCellDateTimeYear = Calendar.current.component(.year, from: currentCellDateTime!)
                let currentCellDateTimeMonth = Calendar.current.component(.month, from: currentCellDateTime!)
                let currentCellDateTimeDay = Calendar.current.component(.day, from: currentCellDateTime!)
                
                let line2Year = Calendar.current.component(.year, from: line2.1)
                let line2Month = Calendar.current.component(.month, from: line2.1)
                let line2Day = Calendar.current.component(.day, from: line2.1)
                
                let line2YearStart = Calendar.current.component(.year, from: line2.0)
                let line2MonthStart = Calendar.current.component(.month, from: line2.0)
                let line2DayStart = Calendar.current.component(.day, from: line2.0)
                
                if currentCellDateTimeYear == line2YearStart && currentCellDateTimeMonth == line2MonthStart && currentCellDateTimeDay == line2DayStart {
                    
                }
                
                //마지막 날짜
                if currentCellDateTimeYear == line2Year && currentCellDateTimeMonth == line2Month && currentCellDateTimeDay == line2Day {
                    //cell.line2.frame.origin.x = cell.frame.origin.x - 5
                    cell.line2.clipsToBounds = true
                    cell.line2.layer.cornerRadius = 4
                    cell.line2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                    
                    //cell.line2.widthAnchor.constraint(equalToConstant: 13).isActive = true
                }
                
                //처음 날짜
                let lineYearStart = Calendar.current.component(.year, from: line2.0)
                let lineMonthStart = Calendar.current.component(.month, from: line2.0)
                let lineDayStart = Calendar.current.component(.day, from: line2.0)
                //시작 날짜
                if lineYearStart == currentCellDateTimeYear && lineMonthStart == currentCellDateTimeMonth && (lineDayStart+1) == currentCellDateTimeDay {
                    cell.line2.clipsToBounds = true
                    cell.line2.layer.cornerRadius = 4
                    cell.line2.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                }
                
                //if current
                
                //오늘 이전이면 라인2의 백그라운드 컬러도 회색으로 바꾼다.
                if currentCellDateTime! < todayDate! {
                    cell.line2.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
        }
        
        for line3 in lineArray3 {
            if line3.0 <= currentCellDateTime! && currentCellDateTime! <= line3.1 {
                cell.line3.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
                
                //line3의 끝날짜 처리
                let currentCellDateTimeYear = Calendar.current.component(.year, from: currentCellDateTime!)
                let currentCellDateTimeMonth = Calendar.current.component(.month, from: currentCellDateTime!)
                let currentCellDateTimeDay = Calendar.current.component(.day, from: currentCellDateTime!)
                
                let line3Year = Calendar.current.component(.year, from: line3.1)
                let line3Month = Calendar.current.component(.month, from: line3.1)
                let line3Day = Calendar.current.component(.day, from: line3.1)
                
                let lineYearStart = Calendar.current.component(.year, from: line3.0)
                let lineMonthStart = Calendar.current.component(.month, from: line3.0)
                let lineDayStart = Calendar.current.component(.day, from: line3.0)
                
                //끝 날짜
                if currentCellDateTimeYear == line3Year && currentCellDateTimeMonth == line3Month && currentCellDateTimeDay == line3Day {
                    cell.line3.clipsToBounds = true
                    cell.line3.layer.cornerRadius = 4
                    cell.line3.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                }
                
                //시작 날짜
                if lineYearStart == currentCellDateTimeYear && lineMonthStart == currentCellDateTimeMonth && (lineDayStart+1) == currentCellDateTimeDay {
                    cell.line3.clipsToBounds = true
                    cell.line3.layer.cornerRadius = 4
                    cell.line3.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                }
                
                if currentCellDateTime! < todayDate! {
                    cell.line3.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
            
        }
        
        for line4 in lineArray4 {
            if line4.0 <= currentCellDateTime! && currentCellDateTime! <= line4.1 {
                cell.line4.backgroundColor = #colorLiteral(red: 1, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
                //line4의 끝날짜 처리
                let currentCellDateTimeYear = Calendar.current.component(.year, from: currentCellDateTime!)
                let currentCellDateTimeMonth = Calendar.current.component(.month, from: currentCellDateTime!)
                let currentCellDateTimeDay = Calendar.current.component(.day, from: currentCellDateTime!)
                
                let line4Year = Calendar.current.component(.year, from: line4.1)
                let line4Month = Calendar.current.component(.month, from: line4.1)
                let line4Day = Calendar.current.component(.day, from: line4.1)
                
                let lineYearStart = Calendar.current.component(.year, from: line4.0)
                let lineMonthStart = Calendar.current.component(.month, from: line4.0)
                let lineDayStart = Calendar.current.component(.day, from: line4.0)
                
                if currentCellDateTimeYear == line4Year && currentCellDateTimeMonth == line4Month && currentCellDateTimeDay == line4Day {
                    cell.line4.clipsToBounds = true
                    cell.line4.layer.cornerRadius = 4
                    cell.line4.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                }
                if lineYearStart == currentCellDateTimeYear && lineMonthStart == currentCellDateTimeMonth && (lineDayStart+1) == currentCellDateTimeDay {
                    cell.line4.clipsToBounds = true
                    cell.line4.layer.cornerRadius = 4
                    cell.line4.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                }
                if currentCellDateTime! < todayDate! {
                    cell.line4.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
                }
            }
        }
        currentPosterTuple = []
        
        return cell
    }
    var todaysIndexPath: IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let lbl = cell?.subviews[1] as! UILabel
        lbl.layer.cornerRadius = lbl.frame.height / 2
        lbl.backgroundColor = UIColor.lightGray
        lbl.textColor = UIColor.white
        
        let cellYear = currentYear
        let cellMonth = currentMonth
        let cellDay = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        let currentCellDateTime = formatter.date(from: cellDateString)
        
        lastSelectedDate = currentCellDateTime//현재 선택된 셀의 date객체
        lastSelectedIndexPath = indexPath
        
        //CalendarVC에 지금 선택된 날짜를 전송하자.
        let userInfo = [ "currentCellDateTime" : currentCellDateTime ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoUp"), object: nil, userInfo: userInfo as [AnyHashable : Any])
        
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
        
        setupViews()
    }
    
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
        line.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        
        line.addSubview(lineLabel)
        lineLabel.leftAnchor.constraint(equalTo: line.leftAnchor).isActive = true
        lineLabel.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        lineLabel.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        lineLabel.bottomAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        
        addSubview(line2)
        line2.topAnchor.constraint(equalTo: line.bottomAnchor , constant: 0.6).isActive = true
        line2.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        
        line2.addSubview(lineLabel2)
        lineLabel2.leftAnchor.constraint(equalTo: line2.leftAnchor).isActive = true
        lineLabel2.rightAnchor.constraint(equalTo: line2.rightAnchor).isActive = true
        lineLabel2.topAnchor.constraint(equalTo: line2.topAnchor).isActive = true
        lineLabel2.bottomAnchor.constraint(equalTo: line2.bottomAnchor).isActive = true
        
        addSubview(line3)
        line3.topAnchor.constraint(equalTo: line2.bottomAnchor , constant: 0.6).isActive = true
        line3.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line3.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        
        line3.addSubview(lineLabel3)
        lineLabel3.leftAnchor.constraint(equalTo: line3.leftAnchor).isActive = true
        lineLabel3.rightAnchor.constraint(equalTo: line3.rightAnchor).isActive = true
        lineLabel3.topAnchor.constraint(equalTo: line3.topAnchor).isActive = true
        lineLabel3.bottomAnchor.constraint(equalTo: line3.bottomAnchor).isActive = true
        
        addSubview(line4)
        line4.topAnchor.constraint(equalTo: line3.bottomAnchor , constant: 0.6).isActive = true
        line4.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line4.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line4.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        
        line4.addSubview(lineLabel4)
        lineLabel4.leftAnchor.constraint(equalTo: line4.leftAnchor).isActive = true
        lineLabel4.rightAnchor.constraint(equalTo: line4.rightAnchor).isActive = true
        lineLabel4.topAnchor.constraint(equalTo: line4.topAnchor).isActive = true
        lineLabel4.bottomAnchor.constraint(equalTo: line4.bottomAnchor).isActive = true
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
    
    let lineLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    //구분선
    let line2: UIView = {
        let line = UIView()
        line.layer.cornerRadius = 0
        line.layer.masksToBounds = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let lineLabel2: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
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
    
    let lineLabel3: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
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
    
    let lineLabel4: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
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








