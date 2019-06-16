//
//  NewCalendarVC.swift
//  SsgSag
//
//  Created by admin on 11/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NewCalendarVC: UIViewController {
    
    
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                dateFormat: "LLLL"
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    var calendarView: VACalendarView!
    
    private let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
    }
    
    private func setCalendar() {
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        view.addSubview(calendarView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            
            let tabbarHeight = self.tabBarController?.tabBar.frame.height
            
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - (tabbarHeight ?? 10)
            )
            
            calendarView.setup()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //weekDaysView.appearance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
        calendarView.setupMonths()
        calendarView.drawVisibleMonth(with: calendarView.contentOffset)
        
        super.viewWillAppear(animated)
    }
    
    private func openSelctedDateTodoList(_ date: Date) {
        print("openSelected \(date)")
        
        let storyboard = UIStoryboard(name: StoryBoardName.newCalendar, bundle: nil)
        guard let selectedTodoViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.selectedTodoViewController) as? SelectedTodoViewController else {return}
        
        self.addChild(selectedTodoViewController)
        selectedTodoViewController.view.frame = self.view.frame
        self.view.addSubview(selectedTodoViewController.view)
        selectedTodoViewController.didMove(toParent: self)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
}

extension NewCalendarVC: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension NewCalendarVC: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10
    }
    
    func rightInset() -> CGFloat {
        return 10
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension NewCalendarVC: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return #colorLiteral(red: 0.3450980392, green: 0.7921568627, blue: 0.4117647059, alpha: 1)
        default:
            return .white
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension NewCalendarVC: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        calendarView.startDate = date
        
       openSelctedDateTodoList(date)
    }
    
}

extension NewCalendarVC: StoreAndFetchPosterDelegate {
    func changePosterInfomation() {
        print("storeAndFetchChangeDelegate")
    }
    
}

