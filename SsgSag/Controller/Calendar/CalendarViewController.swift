//
//  CalendarViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 18/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CalendarViewController: UIViewController {
    
    private var calendar: HJCalendar = HJCalendar()
    private var isFirst: Bool = true
    private var startOffsetX: CGFloat = 0
    private var year: Int = 0
    private var month: Int = 0
    private var currentScrollContentWidth: CGFloat = 0
    
    private let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    var categoryDataSource: CategoryCollectionViewDataSource? {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort,
                                                      calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        month = calendar.component(.month, from: Date())
        year = calendar.component(.year, from: Date())
        navigationItem.title = "\(year)년 \(month)월"
        setupLayout()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isFirst else {
            return
        }
        
        if calendar.months.count > 0 {
            
            calendarCollectionView.scrollToItem(at: IndexPath(item: calendar.months.count / 2,
                                                              section: 0),
                                                at: .centeredHorizontally,
                                                animated: false)
            
            isFirst = false
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        categoryDataSource = CategoryCollectionViewDataSource()
        categoryCollectionView.dataSource = categoryDataSource
        
        let calendarDataSource: CalendarCollectionViewDataSource
            = CalendarDataSourceContainer.shared.getDependency(key: .calendarDataSource)
        calendarCollectionView.dataSource = calendarDataSource
        
        let monthDataSource: MonthCollectionViewDataSource
            = CalendarDataSourceContainer.shared.getDependency(key: .monthDataSource)
        
        let dayDataSource: DayCollectionViewDataSource
            = CalendarDataSourceContainer.shared.getDependency(key: .dayDataSource)
        
        calendarDataSource.connect(with: monthDataSource)
        monthDataSource.connect(with: dayDataSource)
        
        calendarDataSource.months = calendar.getMonths()
        
        calendarCollectionView.register(MonthCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "monthCell")
    }

    @IBAction func touchUpMypageButton(_ sender: UIBarButtonItem) {
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
        
        let myPageNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageNavigator.modalPresentationStyle = .fullScreen
        
        present(myPageNavigator,
                animated: true)
    }
    
    private func reloadDataAndKeepOffset() {
        
        guard let dataSource = calendarCollectionView.dataSource as? CalendarCollectionViewDataSource else {
            return
        }
        
        dataSource.months = calendar.months
        
        // stop scrolling
        calendarCollectionView.setContentOffset(calendarCollectionView.contentOffset,
                                                animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = calendarCollectionView.contentSize
        calendarCollectionView.reloadData()
        calendarCollectionView.layoutIfNeeded()
        let afterContentSize = calendarCollectionView.contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: calendarCollectionView.contentOffset.x
                + (afterContentSize.width
                    - beforeContentSize.width),
            y: calendarCollectionView.contentOffset.y
                + (afterContentSize.height
                    - beforeContentSize.height))
        
        calendarCollectionView.setContentOffset(newOffset,
                                                animated: false)
    }
    
    @IBAction func touchUpCalendarTypeButton(_ sender: Any) {
    }
    
    @IBAction func touchUpCalendarEtcButton(_ sender: Any) {
    }
}

extension CalendarViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentSize.width != 0 {
//            if currentScrollContentWidth != scrollView.contentSize.width {
//                if scrollView.contentOffset.x < scrollView.contentSize.width * 0.3 {    //왼쪽
//                    currentScrollContentWidth = scrollView.contentSize.width
//                    
//                    calendar.addPreviousMonths()
//                    reloadDataAndKeepOffset()
//                } else if scrollView.contentOffset.x > scrollView.contentSize.width * 0.7 { //오른쪽
//                    currentScrollContentWidth = scrollView.contentSize.width
//                    
//                    calendar.addNextMonths()
//                    calendarCollectionView.reloadData()
//                }
//            }
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        print("scrollbegin \(scrollView.contentOffset.x)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x != startOffsetX else {
            return
        }
        
        if scrollView.contentOffset.x > startOffsetX {
            if month == 12 {
                year += 1
                month = 1
            } else {
                month += 1
            }
        } else {
            if month == 1 {
                year -= 1
                month = 12
            } else {
                month -= 1
            }
        }

        navigationItem.title = "\(year)년 \(month)월"
        
        print("scrollend \(scrollView.contentOffset.x)")
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
