//
//  NewCalendarVC.swift
//  SsgSag
//
//  Created by admin on 11/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol CategorySelectedDelegate: class {
    func categorySelectedDelegate(_ multipleSelected: [Int])
}

protocol selectedTodoDelegate: class {
    func changeCurrentWindowDate(_ currentDate: Date)
}

class NewCalendarVC: UIViewController {
    
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var calendarSwitchButton: UIButton!
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                dateFormat: "LLLL"
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var myPageBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var calendarView: VACalendarView!
    
    var categorySelectedDelegate: CategorySelectedDelegate?
    
    private let calendarServiceImp: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    private var multipleSelectedIndex: [Int] = []
    
    private let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    private let category = ["공모전", "대외활동", "동아리", "인턴", "교육강연", "기타"]
    
    private let downloadLink = "https://ssgsag.page.link/install"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let height: CGFloat = 48
        let bounds = navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0,
                                                           y: 0,
                                                           width: bounds.width,
                                                           height: bounds.height + height)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isHidden = false
        if !UserDefaults.standard.bool(forKey: "hasCalendarLoadedBefore") {
            let coachMarkViewController = FirstCoachmarkViewController()
            coachMarkViewController.modalPresentationStyle = .overFullScreen
            let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
            coachMarkViewController.bind(viewModel: CoachMarkViewModel(with: .calendar(.init(x: 0, y: tabBarHeight))))
                self.present(coachMarkViewController,
                                animated: false)
            UserDefaults.standard.setValue(true, forKey: "hasCalendarLoadedBefore")
        }
        
        calendarView.drawMonths()
        calendarView.drawVisibleMonth(with: calendarView.contentOffset)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        
        setCategoryCollection()
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
    
    private func setCategoryCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        categoryCollection.showsHorizontalScrollIndicator = false
        categoryCollection.alwaysBounceHorizontal = true
        
        categoryCollection.allowsMultipleSelection = true
        
        // header
        let allAndFavoriteNib = UINib(nibName: "AllAndFavoriteCollectionReusableView",
                                      bundle: nil)
        
        categoryCollection.register(allAndFavoriteNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "allAndFavoriteHeader")
        
        categoryCollection.register(TempCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "tempHeader")
        
        //footer
        categoryCollection.register(TempCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: "tempFooter")
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
    
    private func openSelctedDateTodoList(_ date: Date) {
        
        let storyboard = UIStoryboard(name: StoryBoardName.newCalendar, bundle: nil)
//        guard let selectedTodoViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.selectedTodoViewController) as? SelectedTodoViewController else {return}
//
//        let selectedTodoViewController = SelectedTodoViewController()
//
//        selectedTodoViewController.delegate = calendarView
//        selectedTodoViewController.currentDate = date
//        selectedTodoViewController.modalPresentationStyle = .overCurrentContext
//
//        present(UINavigationController(rootViewController: selectedTodoViewController),
//                animated: true)
        
        let dayTodoVC = DayTodoViewController()
        dayTodoVC.modalPresentationStyle = .overCurrentContext
        dayTodoVC.currentDate = date
        
        dayTodoVC.callback = { [weak self] in
            guard let contentOffset = self?.calendarView.contentOffset else {
                print("no contentOffset data")
                return
            }
            
            self?.calendarView.drawMonths()
            self?.calendarView.drawVisibleMonth(with: contentOffset)
            
            self?.tabBarController?.tabBar.isHidden = false
        }
        
        let navigationVC = UINavigationController(rootViewController: dayTodoVC)
        navigationVC.modalPresentationStyle = .overFullScreen
        
        tabBarController?.tabBar.isHidden = true
        present(navigationVC, animated: false)
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
        
    }
    
    @IBAction func touchUpMyPageButton(_ sender: UIBarButtonItem) {
        if let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool {
            if isTryWithoutLogin {
                simpleAlertwithHandler(title: "마이페이지", message: "로그인 후 이용해주세요") { _ in
                    
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
                    
                    let rootNavigationController = UINavigationController(rootViewController: viewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = rootNavigationController
                    
                    rootNavigationController.view.layoutIfNeeded()
                    
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        window.rootViewController = rootNavigationController
                    }, completion: nil)
                }
                return
            }
        }
        
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        
        present(myPageViewNavigator,
                animated: true)
    }
    
    @IBAction func touchUpCalendarSwitchButton(_ sender: UIButton) {
        let listViewController = CalendarListViewController()
        
        let dateText = monthHeaderView.monthLabel.text
        
        var intText = ""
        
        dateText?.forEach {
            if $0 == "년" {
                listViewController.currentYear = Int(intText)
                intText = ""
            } else if $0 == "월" {
                listViewController.currentMonth = Int(intText)
            } else if $0 >= "0" && $0 <= "9" {
                intText.append($0)
            }
        }
        
        navigationController?.pushViewController(listViewController, animated: false)
    }
    
    @IBAction func touchUpCalendarEtcButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "공유하기",
                                        style: .default) { [weak self] (action) in

            let layer = UIApplication.shared.keyWindow!.layer
            let scale = UIScreen.main.scale
            
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
            
            guard let context = UIGraphicsGetCurrentContext(),
                let downloadLink = self?.downloadLink else {
                return
            }
            
            layer.render(in: context)
            let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            var objectsToshare: [Any] = []
            
            guard screenshotImage != nil else {
                return
            }
            
            objectsToshare.append(screenshotImage)
            
            objectsToshare.append("슥삭 다운로드 바로가기")
            
            objectsToshare.append("\(downloadLink)\n")

            self?.addObjects(with: objectsToshare)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true)
        
    }
    
    private func addObjects(with objectsToshare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToshare,
                                                  applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.modalPresentationStyle = .fullScreen
        self.present(activityVC, animated: true, completion: nil)
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
        return 0
    }
    
    func rightInset() -> CGFloat {
        return 0
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
            return .clear
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

extension NewCalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
//        return category.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                      for: indexPath) as! CateogoryCollectionViewCell
        cell.categoryLabel.text = category[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = self.estimatedFrame(text: category[indexPath.item],
                                                          font: UIFont.systemFont(ofSize: 12)).width
        
        return CGSize(width: collectionViewCellWidth + 5, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: multiple selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = PosterCategory(rawValue: indexPath.item) else {
            return
        }
        
        guard let cell
            = collectionView.cellForItem(at: indexPath) as? CateogoryCollectionViewCell else { return }
        
        multipleSelectedIndex.append(indexPath.item)
        
        categorySelectedDelegate?.categorySelectedDelegate(multipleSelectedIndex)
        
        if cell.isSelected == true {
            cell.categoryLabel.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
            cell.categoryLabel.textColor = category.categoryColors()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CateogoryCollectionViewCell else {return}
        
        if let index = multipleSelectedIndex.firstIndex(of: indexPath.item) {
            multipleSelectedIndex.remove(at: index)
        }
        
        categorySelectedDelegate?.categorySelectedDelegate(multipleSelectedIndex)
        
        cell.categoryLabel.backgroundColor = .clear
        cell.categoryLabel.textColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header
                = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "allAndFavoriteHeader",
                                                                  for: indexPath)
                    as? AllAndFavoriteCollectionReusableView else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            header.delegate = self
            
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "tempFooter",
                                                                   for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 90, height: collectionView.frame.height - 2)
    }
}

extension NewCalendarVC: MenuSelectedDelegate {
    func selectedMenu(index: Int) {
        categorySelectedDelegate?.categorySelectedDelegate([index])
    }
}

