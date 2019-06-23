//
//  SelectedTodoViewController.swift
//  SsgSag
//
//  Created by admin on 14/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SelectedTodoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    static let tableViewCellReuseIdentifier = "DetailTodoListTableViewCell"
    
    private let testNUmber = ["1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    
    private let firstTableView: UITableView = {
        let label = UITableView()
        label.backgroundColor = .red
        label.showsVerticalScrollIndicator = false
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.separatorStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondTableView: UITableView = {
        let label = UITableView()
        label.backgroundColor = .blue
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.showsVerticalScrollIndicator = false
        label.separatorStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thirdTableView: UITableView = {
        let label = UITableView()
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.showsVerticalScrollIndicator = false
        label.separatorStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fourthTableView: UITableView = {
        let label = UITableView()
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.showsVerticalScrollIndicator = false
        label.separatorStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fifthTableView: UITableView = {
        let label = UITableView()
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.showsVerticalScrollIndicator = false
        label.separatorStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var firstDayPosters: [Posters] = []
    
    private var secondDayPosters: [Posters] = []
    
    private var thirdDayPosters: [Posters] = []
    
    private var fourthDayPosters: [Posters] = []
    
    private var fifthDayPosters: [Posters] = []
    
    var currentDate: Date? {
        didSet {
            guard let date = currentDate else {return}
            
            let firstDate = date.changeDaysBy(days: -2)
            
            let secondDate = date.changeDaysBy(days: -1)
            
            let fourthDate = date.changeDaysBy(days: 1)
            
            let fifthDate = date.changeDaysBy(days: 2)
            
            for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
                guard let endDateString = poster.posterEndDate else {return}
                let endDate = DateCaculate.stringToDateWithGenericFormatter(using: endDateString)
                
                if DateCaculate.isSameDate(firstDate, endDate) {
                    firstDayPosters.append(poster)
                }
                
                if DateCaculate.isSameDate(secondDate, endDate) {
                    secondDayPosters.append(poster)
                }
                
                if DateCaculate.isSameDate(date, endDate) {
                    thirdDayPosters.append(poster)
                }
                
                if DateCaculate.isSameDate(fourthDate, endDate) {
                    fourthDayPosters.append(poster)
                }
                
                if DateCaculate.isSameDate(fifthDate, endDate) {
                    fifthDayPosters.append(poster)
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let date = currentDate else {return}
        
        addTapGesture()
        
        setDelegate()
        
        setCurrentContentOffset(with: date)
        
        setScrollView()
        
        addTableView()
    }
    
    private func setScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        
        scrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func setCurrentContentOffset(with selectedDate: Date) {
        
        let numberOfCurrentMonthDays = getCurrentMonthsDay(selectedDate)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * numberOfCurrentMonthDays, height: self.view.frame.height)
        
        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 2, y: 0), animated: false)
    }
    
    private func getCurrentMonthsDay(_ selectedDay: Date) -> CGFloat{
        return 5
    }
    
    private func setDelegate() {
        firstTableView.delegate = self
        secondTableView.delegate = self
        thirdTableView.delegate = self
        fourthTableView.delegate = self
        fifthTableView.delegate = self
        
        firstTableView.dataSource = self
        secondTableView.dataSource = self
        thirdTableView.dataSource = self
        fourthTableView.dataSource = self
        fifthTableView.dataSource = self
        
        firstTableView.separatorStyle = .none
        secondTableView.separatorStyle = .none
        thirdTableView.separatorStyle = .none
        fourthTableView.separatorStyle = .none
        fifthTableView.separatorStyle = .none
        
        firstTableView.register(UINib(nibName: "DetailTodoListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier)
        
        secondTableView.register(UINib(nibName: "DetailTodoListTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier)
        
        thirdTableView.register(UINib(nibName: "DetailTodoListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier)
        
        fourthTableView.register(UINib(nibName: "DetailTodoListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier)
        
        fifthTableView.register(UINib(nibName: "DetailTodoListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier)
        
    }
    
    private func addTableView() {
        scrollView.addSubview(firstTableView)
        scrollView.addSubview(secondTableView)
        scrollView.addSubview(thirdTableView)
        scrollView.addSubview(fourthTableView)
        scrollView.addSubview(fifthTableView)
        
        firstTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        firstTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        firstTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.88).isActive = true
        firstTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
        
        secondTableView.centerXAnchor.constraint(equalTo: firstTableView.centerXAnchor, constant: self.view.frame.width).isActive = true
        secondTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        secondTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.88).isActive = true
        secondTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
        
        thirdTableView.centerXAnchor.constraint(equalTo: secondTableView.centerXAnchor, constant: self.view.frame.width).isActive = true
        thirdTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        thirdTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.88).isActive = true
        thirdTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
        
        fourthTableView.centerXAnchor.constraint(equalTo: thirdTableView.centerXAnchor, constant: self.view.frame.width).isActive = true
        fourthTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        fourthTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.88).isActive = true
        fourthTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
        
        fifthTableView.centerXAnchor.constraint(equalTo: fourthTableView.centerXAnchor, constant: self.view.frame.width).isActive = true
        fifthTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        fifthTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.88).isActive = true
        fifthTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDisView))
        scrollView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    @objc private func dismissDisView() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("SelectedTodoViewController is deleted")
    }
    
    private func setDefaultScrollViewAndReloadTableView(using by: Int) {
        
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 2, y: 0), animated: false)
        
        currentDate = currentDate?.changeDaysBy(days: by)
        
        guard let date = currentDate else {return}
        
        firstDayPosters = []
        secondDayPosters = []
        thirdDayPosters = []
        fourthDayPosters = []
        fifthDayPosters = []
        
        let firstDate = date.changeDaysBy(days: -2)
        
        let secondDate = date.changeDaysBy(days: -1)
        
        let fourthDate = date.changeDaysBy(days: 1)
        
        let fifthDate = date.changeDaysBy(days: 2)
        
        for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
            guard let endDateString = poster.posterEndDate else {return}
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: endDateString)
            
            if DateCaculate.isSameDate(firstDate, endDate) {
                firstDayPosters.append(poster)
            }
            
            if DateCaculate.isSameDate(secondDate, endDate) {
                secondDayPosters.append(poster)
            }
            
            if DateCaculate.isSameDate(date, endDate) {
                thirdDayPosters.append(poster)
            }
            
            if DateCaculate.isSameDate(fourthDate, endDate) {
                fourthDayPosters.append(poster)
            }
            
            if DateCaculate.isSameDate(fifthDate, endDate) {
                fifthDayPosters.append(poster)
            }
        }
        
        firstTableView.reloadData()
        secondTableView.reloadData()
        thirdTableView.reloadData()
        fourthTableView.reloadData()
        fifthTableView.reloadData()
        
    }
    
}

extension SelectedTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == firstTableView {
            return firstDayPosters.count
        } else if tableView == secondTableView {
            return secondDayPosters.count
        } else if tableView == thirdTableView {
            return thirdDayPosters.count
        } else if tableView == fourthTableView {
            return fourthDayPosters.count
        } else {
            return fifthDayPosters.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == thirdTableView {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier) as? DetailTodoListTableViewCell else {
                return .init()
            }
            
            tableViewCell.poster = thirdDayPosters[indexPath.row]
            return tableViewCell
        } else if tableView == firstTableView {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier) as? DetailTodoListTableViewCell else {
                return .init()
            }
            
            tableViewCell.poster = firstDayPosters[indexPath.row]
            return tableViewCell
        } else if tableView == secondTableView {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier) as? DetailTodoListTableViewCell else {
                return .init()
            }
            
            tableViewCell.poster = secondDayPosters[indexPath.row]
            return tableViewCell
        } else if tableView == fourthTableView {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier) as? DetailTodoListTableViewCell else {
                return .init()
            }
            
            tableViewCell.poster = fourthDayPosters[indexPath.row]
            return tableViewCell
        } else if tableView == fifthTableView {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SelectedTodoViewController.tableViewCellReuseIdentifier) as? DetailTodoListTableViewCell else {
                return .init()
            }
            
            tableViewCell.poster = fifthDayPosters[indexPath.row]
            return tableViewCell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == secondTableView {
            return 120
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselct")
    }
    
    header
    
}

extension SelectedTodoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        
        if scrollView.contentOffset.x < -80 {
            setDefaultScrollViewAndReloadTableView(using: -3)
        } else if scrollView.contentOffset.x > self.view.frame.width * 4 + 100 {
            setDefaultScrollViewAndReloadTableView(using: 3)
        }
        
    }
    
}

extension SelectedTodoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view != self.scrollView
        {
            return false
        }
        
        return true
    }
}

extension Date {
    func changeDaysBy(days : Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
