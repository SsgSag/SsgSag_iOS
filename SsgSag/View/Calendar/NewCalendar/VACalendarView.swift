//
//  VACalendarView.swift
//  VACalendar
//
//  Created by Anton Vodolazkyi on 20.02.18.
//  Copyright © 2018 Vodolazkyi. All rights reserved.
//

import UIKit

public enum VASelectionStyle {
    case single, multi
}

public enum VACalendarScrollDirection {
    case horizontal, vertical
}

public enum VACalendarViewType {
    case month, week
}

@objc
public protocol VACalendarViewDelegate: class {
    // use this method for single selection style
    @objc optional func selectedDate(_ date: Date)
    // use this method for multi selection style
    @objc optional func selectedDates(_ dates: [Date])
}

public class VACalendarView: UIScrollView {
    
    public weak var monthDelegate: VACalendarMonthDelegate?
    public weak var dayViewAppearanceDelegate: VADayViewAppearanceDelegate?
    public weak var monthViewAppearanceDelegate: VAMonthViewAppearanceDelegate?
    public weak var calendarDelegate: VACalendarViewDelegate?
    
    public var scrollDirection: VACalendarScrollDirection = .horizontal
    // use this for vertical scroll direction
    public var monthVerticalInset: CGFloat = 20
    public var monthVerticalHeaderHeight: CGFloat = 20
    
    public var startDate = Date()
    public var showDaysOut = true
    public var selectionStyle: VASelectionStyle = .single
    
    private var calculatedWeekHeight: CGFloat = 100
    private let calendar: VACalendar
    var monthViews = [VAMonthView]()
    var monthTodoData: [MonthTodoData] = []
    
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    private var numberOfWeek: MaxNumberOfWeekType?
    
    // MARK: - maxNumberOfWeek 현재 달의 끝 값을 구할 수 있음
    enum MaxNumberOfWeekType: Int {
        case six = 5
        case seven = 6
        
        var getMultiplier: CGFloat {
            switch self {
            case .six:
                return 6
            case .seven:
                return 7
            }
        }
        
    }
    
    private let maxNumberOfWeek = 7
    
    private let numberDaysInWeek = 7
    
    private func getWeekHeight(_ numberOfWeekDays: Int) -> CGFloat {
        return (frame.height - 44) / CGFloat(MaxNumberOfWeekType(rawValue: numberOfWeekDays)?.getMultiplier ?? 6)
    }
    
    private var weekHeight: CGFloat {
        switch scrollDirection {
        case .horizontal:
            return frame.height / CGFloat(numberOfWeek?.getMultiplier ?? 6)
        default:
            return 1
        }
    }
    
    private var viewType: VACalendarViewType = .month
    
    private var currentMonth: VAMonthView? {
        return getMonthView(with: contentOffset)
    }
    
    // FIXME: - 현재 달의 일 수를 설정하자
    private func getMaxNumberOfWeek() -> Int {
        return 7
    }
    
    public convenience init() {
        let defaultCalendar: Calendar = {
            var calendar = Calendar.current
            calendar.firstWeekday = 1
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            return calendar
        }()
        
        let calendar = VACalendar(calendar: defaultCalendar)
        self.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300), calendar: calendar)
    }
    
    public init(frame: CGRect, calendar: VACalendar) {
        self.calendar = calendar
        
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // specify all properties before calling setup()
    public func setup() {
        delegate = self
        calendar.delegate = self
        directionSetup()
        calculateContentSize()
        setupMonths()
        scrollToStartDate()
    }
    
    public func nextMonth() {
        switch scrollDirection {
        case .horizontal:
            let x = contentOffset.x + frame.width
            guard x < contentSize.width else { return }
            
            setContentOffset(CGPoint(x: x, y: 0), animated: false)

            drawVisibleMonth(with: contentOffset)
        case .vertical: break
        }
        
    }
    
    public func previousMonth() {
        switch scrollDirection {
        case .horizontal:
            let x = contentOffset.x - frame.width
            guard x >= 0 else { return }
            
            setContentOffset(CGPoint(x: x, y: 0), animated: false)
            drawVisibleMonth(with: contentOffset)
        case .vertical: break
            
        }
    }
    
    public func selectDates(_ dates: [Date]) {
        calendar.deselectAll()
        calendar.selectDates(dates)
    }
    
    public func setAvailableDates(_ availability: DaysAvailability) {
        calendar.setDaysAvailability(availability)
    }
    
    public func setSupplementaries(_ data: [(Date, [VADaySupplementary])]) {
        calendar.setSupplementaries(data)
    }
    
    public func changeViewType() {
        switch scrollDirection {
        case .horizontal:
            viewType = viewType == .month ? .week : .month
            calculateContentSize()
            drawMonths()
            scrollToStartDate()
        case .vertical: break
        }
    }
    
    // MARK: Private Methods.
    private func directionSetup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        switch scrollDirection {
        case .horizontal:
            isPagingEnabled = true
        case .vertical: break
        }
    }
    
    private func calculateContentSize() {
        switch scrollDirection {
        case .horizontal:
            switch viewType {
            case .month:
                contentSize.width = frame.width * CGFloat(calendar.months.count)
            case .week:
                let weeksWidth = calendar.months.reduce(0) { sum, month -> CGFloat in
                    return sum + (CGFloat(month.weeks.count) * frame.width)
                }
                contentSize.width = weeksWidth
            }
        default:
            break
        }
    }
    
    func setupMonths() {
        
        monthViews = calendar.months.map {
            VAMonthView(month: $0,
                        showDaysOut: showDaysOut,
                        weekHeight: getWeekHeight($0.numberOfWeeks),
                        viewType: viewType)
        }
        
        monthViews.forEach { addSubview($0) }
        
        drawMonths()
    }
    
    func drawMonths() {
        monthViews.forEach { $0.clean() }
        
        monthViews.enumerated().forEach { index, monthView in
            switch scrollDirection {
            case .horizontal:
                switch viewType {
                case .month:
                    let x = index == 0 ? 0 : monthViews[index - 1].frame.maxX
                    monthView.frame = CGRect(x: x, y: 0, width: self.frame.width, height: self.frame.height)
                case .week:
                    let x = index == 0 ? 0 : monthViews[index - 1].frame.maxX
                    let monthWidth = self.frame.width * CGFloat(monthView.numberOfWeeks)
                    monthView.frame = CGRect(x: x, y: 0, width: monthWidth, height: self.frame.height)
                }
            case .vertical:
                let y = index == 0 ? 0 : monthViews[index - 1].frame.maxY + monthVerticalInset
                let height = (CGFloat(monthView.numberOfWeeks) * weekHeight) + monthVerticalHeaderHeight
                monthView.frame = CGRect(x: 0, y: y, width: self.frame.width, height: height)
            }
        }
    }
    
    func scrollToStartDate() {
        let startMonth = monthViews.first(where: { $0.month.dateInThisMonth(startDate) })
        var offset: CGPoint = startMonth?.frame.origin ?? .zero
        
        setContentOffset(offset, animated: false)
        drawVisibleMonth(with: contentOffset)
        
        if viewType == .week {
            let weekOffset = startMonth?.week(with: startDate)?.frame.origin.x ?? 0
            let inset = startMonth?.monthViewAppearanceDelegate?.leftInset?() ?? 0
            offset.x += weekOffset - inset
            setContentOffset(offset, animated: false)
        }
        
    }
    
    private func getMonthView(with offset: CGPoint) -> VAMonthView? {
        switch scrollDirection {
        case .horizontal:
            switch viewType {
            case .month:
                return monthViews.first(where: { $0.frame.midX >= offset.x })
            default:
                let visibleRect = CGRect(x: offset.x, y: offset.y, width: frame.width, height: frame.height)
                return monthViews.first(where: { $0.frame.intersects(visibleRect) })
            }
        default:
            return monthViews.first(where: { $0.frame.midY >= offset.y })
        }
    }
    
    func drawVisibleMonth(with offset: CGPoint) {
        switch scrollDirection {
        case .horizontal:
            guard let currentIndex
                = monthViews.enumerated().first(where: { $0.element.frame.midX >= offset.x })?.offset else {
                    return
            }
            
            monthViews.enumerated().forEach { index, month in
                if index == currentIndex || index + 1 == currentIndex || index - 1 == currentIndex {
                    month.delegate = self
                    
                    let componentYear = Calendar.current.component(.year, from: month.month.date)
                    let componentMonth = Calendar.current.component(.month, from: month.month.date)
                    
                    self.calendarService.requestMonthTodoList(year: String(componentYear),
                                                              month: String(componentMonth), [0,1,2,4,7,8], favorite: 0) { [weak self] result in
                        switch result {
                        case .success(let monthTodoData):
                            self?.monthTodoData = monthTodoData

                            let before = monthTodoData.count
                            let setOfData = Set(monthTodoData)
                            let after = setOfData.count
                            if before != after {
                                assertionFailure()
                            }
                            
                            DispatchQueue.main.async {
                                month.setupWeeksView(with: (self?.viewType)!,
                                                     monthTodoData: monthTodoData)
                            }
                        case .failed(let error):
                            print(error)
                            return
                        }
                    }
                    
                } else {
//                    month.clean()
                }
            }
            
        case .vertical:
            let first: ((offset: Int, element: VAMonthView)) -> Bool = { $0.element.frame.minY >= offset.y }
            guard let currentIndex = monthViews.enumerated().first(where: first)?.offset else { return }
            
            monthViews.enumerated().forEach { index, month in
                if index >= currentIndex - 1 && index <= currentIndex + 1 {
                    month.delegate = self
                    month.setupWeeksView(with: viewType, monthTodoData: monthTodoData)
                } else {
                    month.clean()
                }
            }
        }
    }
    
    private func getNumberOfWeeksDays(_ offset: CGPoint) {
        numberOfWeek = MaxNumberOfWeekType(rawValue: monthViews.first(where: { $0.frame.midX >= offset.x })?.month.numberOfWeeks ?? 6)
    }
    
    
    
}

extension VACalendarView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let frameWidth: CGFloat = self.frame.width
        
        // FIXME: - 달력 스와이프시 속도 증가 시킬 수 있습니다.
        UIView.animate(withDuration: 0.1, animations: {
            var contentOffsetX = scrollView.contentOffset.x
                
            if contentOffsetX.truncatingRemainder(dividingBy: frameWidth) == 0.0 {
                    
                DispatchQueue.main.async {
                    guard let monthView = self.getMonthView(with: scrollView.contentOffset) else { return }
                    
                    self.getNumberOfWeeksDays(scrollView.contentOffset)
                    
                    self.monthDelegate?.monthDidChange(monthView.month.date)
                    
                    self.drawVisibleMonth(with: scrollView.contentOffset)
                }
            }
        })
    }
    
}

extension VACalendarView: VACalendarViewDelegate {
    func selectedDate(_ date: Date) {
        //print(date)
    }
}

extension VACalendarView: VACalendarDelegate {
    
    func selectedDaysDidUpdate(_ days: [VADay]) {
        let dates = days.map { $0.date }
        calendarDelegate?.selectedDates?(dates)
    }
    
}

extension VACalendarView: VAMonthViewDelegate {
    
    func dayStateChanged(_ day: VADay, in month: VAMonth) {
        switch selectionStyle {
        case .single:
            
//            guard day.state == .available  else {
//
//                if day.state == .selected {
////                    calendar.deselectAll()
////                    calendar.setDaySelectionState(day, state: .selected)
//                    calendarDelegate?.selectedDate?(day.date)
//                }
//
//                return
//            }
            
//            calendar.deselectAll()
//            calendar.setDaySelectionState(day, state: .selected)
            calendarDelegate?.selectedDate?(day.date)
            
        case .multi:
            calendar.setDaySelectionState(day, state: day.reverseSelectionState)
        }
    }
    
}

extension VACalendarView: selectedTodoDelegate {
    func changeCurrentWindowDate(_ currentDate: Date) {
        let day = VADay(date: currentDate, state: .available, calendar: Calendar.current)
        
        calendar.deselectAll()
        calendar.setDaySelectionState(day, state: .selected)
        
        // FIXME: - 달이 바뀌면 scrollview의 달도 바뀌도록 바꿔야합니다.
        // Ex: changeMonthIfmonthChanged(currentDate)
    }
}

extension VACalendarView: CategorySelectedDelegate {
    
    func categorySelectedDelegate(_ multipleSelected: [Int]) {
        
        for monthView in self.monthViews {
            for weekView in monthView.weekViews {
                for dayView in weekView.dayViews {
                    dayView.drawEventWithSelectedIndex(multipleSelected,
                                                       monthTodos: monthTodoData)
                }
            }
        }
        
        print("VACalendarView \(multipleSelected)")
    }
}
