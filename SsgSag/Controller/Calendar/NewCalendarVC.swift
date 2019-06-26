//
//  NewCalendarVC.swift
//  SsgSag
//
//  Created by admin on 11/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol CategorySelectedDelegate: class {
    func categorySelectedDelgate(_ multipleSelected: [Int])
}

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
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var calendarView: VACalendarView!
    
    var categorySelectedDelegate: CategorySelectedDelegate?
    
    private var multipleSelectedIndex: [Int] = []
    
    private let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    private let category = ["전체", "즐겨찾기", "공모전", "대외활동", "동아리", "인턴", "교육강연", "기타"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        
        setCategoryCollection()
    }
    
    private func setCategoryCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        categoryCollection.showsHorizontalScrollIndicator = false
        categoryCollection.alwaysBounceHorizontal = true
        
        categoryCollection.allowsMultipleSelection = true
    }
    
    private func setCalendar() {
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
                
        categorySelectedDelegate = calendarView
        
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
        
        var height: CGFloat = view.frame.height - 20
        
        if calendarView.frame == .zero {
            
            let tabbarHeight = self.tabBarController?.tabBar.frame.height
            
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - 83
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
        
        let storyboard = UIStoryboard(name: StoryBoardName.newCalendar, bundle: nil)
        guard let selectedTodoViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.selectedTodoViewController) as? SelectedTodoViewController else {return}
        
        selectedTodoViewController.delegate = calendarView
        
        self.addChild(selectedTodoViewController)
        selectedTodoViewController.currentDate = date
        selectedTodoViewController.view.frame = self.view.frame
        self.view.addSubview(selectedTodoViewController.view)
        selectedTodoViewController.didMove(toParent: self)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
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
            return #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8588235294, alpha: 1)
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

extension NewCalendarVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CateogoryCollectionViewCell
        cell.categoryLabel.text = category[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = self.estimatedFrame(text: category[indexPath.item],
                                                          font: UIFont.systemFont(ofSize: 14)).width
        return CGSize(width: collectionViewCellWidth + 5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: multiple selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let category = CategoryState(rawValue: indexPath.item) else {return}
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CateogoryCollectionViewCell else {return}
        
        multipleSelectedIndex.append(indexPath.item)
        
        categorySelectedDelegate?.categorySelectedDelgate(multipleSelectedIndex)
        
        if cell.isSelected == true {
            cell.categoryLabel.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 0.05)
            cell.categoryLabel.textColor = category.categoryTextColor
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CateogoryCollectionViewCell else {return}
        
        if let index = multipleSelectedIndex.index(of: indexPath.item) {
            multipleSelectedIndex.remove(at: index)
        }
        
        categorySelectedDelegate?.categorySelectedDelgate(multipleSelectedIndex)
        
        cell.categoryLabel.backgroundColor = .clear
        cell.categoryLabel.textColor = .black
    }
    
}

private let category = ["전체", "즐겨찾기", "공모전", "대외활동", "동아리", "인턴", "교육강연"]

enum CategoryState: Int {
    case all = 0
    case favorite = 1
    case competition = 2
    case activities = 3
    case circles = 4
    case intern = 5
    case education = 6
    case other = 7
    
    var koreanLanguage: String {
        switch self {
        case .all:
            return "전체"
        case .favorite:
            return "즐겨찾기"
        case .competition:
            return "공모전"
        case .activities:
            return "대외활동"
        case .circles:
            return "동아리"
        case .intern:
            return "인턴"
        case .education:
            return "교육강연"
        case .other:
            return "기타"
        }
    }
    
    var categoryTextColor: UIColor {
        switch self {
        case .all:
            return #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        case .favorite:
            return #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        case .competition:
            return #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
        case .activities:
            return #colorLiteral(red: 0.9960784314, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
        case .circles:
            return #colorLiteral(red: 0.968627451, green: 0.7137254902, blue: 0.1921568627, alpha: 1)
        case .intern:
            return #colorLiteral(red: 0.3725490196, green: 0.1490196078, blue: 0.8039215686, alpha: 1)
        case .education:
            return #colorLiteral(red: 0.1803921569, green: 0.7411764706, blue: 0.4784313725, alpha: 1)
        case .other:
            return #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        }
    }
}
