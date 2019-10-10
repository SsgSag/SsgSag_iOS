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
        
        navigationItem.title = "월"
        setupLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        categoryDataSource = CategoryCollectionViewDataSource()
        categoryCollectionView.dataSource = categoryDataSource
        
        let calendarDataSource: CalendarCollectionViewDataSource = CalendarDataSourceContainer.shared.getDependency(key: .calendarDataSource)
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
    
    @IBAction func touchUpCalendarTypeButton(_ sender: Any) {
    }
    
    @IBAction func touchUpCalendarEtcButton(_ sender: Any) {
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
