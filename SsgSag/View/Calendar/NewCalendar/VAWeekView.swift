//
//  VAWeekView.swift
//  VACalendar
//
//  Created by Anton Vodolazkyi on 20.02.18.
//  Copyright © 2018 Vodolazkyi. All rights reserved.
//

import UIKit

protocol VAWeekViewDelegate: class {
    func dayStateChanged(_ day: VADay, in week: VAWeek)
}

class VAWeekView: UIView {
    
    weak var dayViewAppearanceDelegate: VADayViewAppearanceDelegate? {
        return (superview as? VAMonthView)?.dayViewAppearanceDelegate
    }
    
    weak var delegate: VAWeekViewDelegate?
    
    private let showDaysOut: Bool
    private lazy var dayWidth = self.frame.width / 7
    private let week: VAWeek
    var dayViews = [VADayView]()
    
    init(week: VAWeek, showDaysOut: Bool) {
        self.week = week
        self.showDaysOut = showDaysOut
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDays(monthTodoData: [MonthTodoData],
                   categoryList: [Int],
                   favorite: Int) {
        dayViews = []
        
        var x: CGFloat = 0
        
        week.days.enumerated().forEach { index, day in
            let dayView = VADayView(day: day)
            dayView.frame = CGRect(x: x, y: 3, width: dayWidth, height: frame.height)
            x = dayView.frame.maxX
            dayView.delegate = self
            dayViews.append(dayView)
            
            if showDaysOut || (!showDaysOut && dayView.day.state != .out) {
                addSubview(dayView)
                dayView.setupDay(monthTodoData: monthTodoData,
                                 categoryList: categoryList,
                                 favorite: favorite)
            }
        }
        
    }
    
    func contains(date: Date) -> Bool {
        return week.dateInThisWeek(date)
    }
    
}

extension VAWeekView: VADayViewDelegate {
    
    func dayStateChanged(_ day: VADay) {
        delegate?.dayStateChanged(day, in: week)
    }
    
}
