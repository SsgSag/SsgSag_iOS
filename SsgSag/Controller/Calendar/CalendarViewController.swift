//
//  CalendarViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 18/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    private let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "dl"
        setNavigationBar(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        calendarCollectionView.register(MonthCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "monthCell")
    }

}

extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell",
                                                            for: indexPath)
            as? MonthCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
}
