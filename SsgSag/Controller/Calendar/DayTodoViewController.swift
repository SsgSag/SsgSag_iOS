//
//  DayTodoViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 30/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DayTodoViewController: UIViewController {

    lazy var pagingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        return collectionView
    }()
    
    var currentDate: Date?
    private var todoDatas: [MonthTodoData] = []
    private var sortedTodoDatas: [[CalendarData]] = []
    private var totalTodoDatas: [[CalendarData]] = []
    var dataPointer = 0
    var callback: (()->())?
    
    private let calendar = Calendar.current
    private let calendarServiceImp: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    private var indexOfCellBeforeDragging = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4656999144)
        
        setupRequestDate()
        setupLayout()
        setupCollectionView()
        pagingCollectionView.prefetchDataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if totalTodoDatas.count > 0 {
            guard let currentDate = currentDate else {
                return
            }
            
            let day = calendar.component(.day, from: currentDate)
            
            pagingCollectionView.scrollToItem(at: IndexPath(item: day - 1,
                                                            section: 0),
                                              at: .centeredHorizontally,
                                              animated: false)
        }
    }
    
    private func setupRequestDate() {
        guard let currentDate = currentDate else { return }
        
        requestData(right: true, currentDate)
        
//        requestOtherMonth(currentDate: currentDate)
    }
    
    private func requestOtherMonth(currentDate: Date) {
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        var dateComponents = DateComponents()
        
        if day == 1 {
            if month == 1 {
                dateComponents.year = year - 1
                dateComponents.month = 12
                guard let date = calendar.date(from: dateComponents) else {
                    return
                }
                requestData(right: false, date)
            } else {
                dateComponents.year = year
                dateComponents.month = month - 1
                guard let date = calendar.date(from: dateComponents) else {
                    return
                }
                requestData(right: false, date)
            }
        } else if day == 30 || day == 31 {
            if month == 12 {
                dateComponents.year = year + 1
                dateComponents.month = 1
                guard let date = calendar.date(from: dateComponents) else {
                    return
                }
                requestData(right: true, date)
            } else {
                dateComponents.year = year
                dateComponents.month = month + 1
                guard let date = calendar.date(from: dateComponents) else {
                    return
                }
                requestData(right: true, date)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(pagingCollectionView)
        
        pagingCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 88).isActive = true
        pagingCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -88).isActive = true
        pagingCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        pagingCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let todoListNib = UINib(nibName: "TodoListCollectionViewCell",
                                bundle: nil)
        pagingCollectionView.register(todoListNib,
                                      forCellWithReuseIdentifier: "todoListCell")
    }
    
    private func requestData(right: Bool, _ date: Date) {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        calendarServiceImp.requestMonthTodoList(year: String(year),
                                                month: String(month)) { [weak self] dataResponse in
            guard let self = self else {
                return
            }
            
            switch dataResponse {
            case .success(let todoData):
                self.todoDatas = todoData
                
                self.makeSortedTodoDatas(date: date)
                
                if self.totalTodoDatas.isEmpty {
                    self.totalTodoDatas = self.sortedTodoDatas
                } else if self.totalTodoDatas[0][0].date < self.sortedTodoDatas[0][0].date {
                    self.totalTodoDatas.append(contentsOf: self.sortedTodoDatas)
                } else if self.totalTodoDatas[0][0].date > self.sortedTodoDatas[0][0].date {
                    self.totalTodoDatas.insert(contentsOf: self.sortedTodoDatas, at: 0)
                }
                
                DispatchQueue.main.async {
                    if right {
                        self.pagingCollectionView.reloadData()
                    } else {
//                        self.reloadDataAndKeepOffset()
                    }
                }
            case .failed(let error):
                assertionFailure(error.localizedDescription)
                return
            }
        }
    }
    
    private func calculateIndexPathsForReloading(from newArtworks: [MonthTodoData]) -> [IndexPath] {
        let startIndex = totalTodoDatas.count - newArtworks.count
        let endIndex = startIndex + newArtworks.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissDayTodoViewController()
    }
    
    private func makeSortedTodoDatas(date: Date) {
        sortedTodoDatas = []

        var components = DateComponents()
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = 1
        
        guard let firstDate = calendar.date(from: components) else {
            return
        }
        
        var previousDate = firstDate.changeDaysBy(days: -1)
        var previousDay = 0
        var position = 0
        
        for (_, todoData) in todoDatas.enumerated() {
            guard let posterEndDate = todoData.posterEndDate else { return }
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: posterEndDate)
            let day = calendar.component(.day, from: endDate)
            
            if endDate < previousDate {
                sortedTodoDatas[day-1][0].todoData.append(todoData)
                continue
            }
            
            if previousDay + 1 < day {
                for numberOfDays in 1..<day - previousDay {
                    sortedTodoDatas.append([CalendarData(date: previousDate.changeDaysBy(days: numberOfDays),
                                                         todoData: [])])
                    position += 1
                }
            }
            
            if day > previousDay {
                sortedTodoDatas.append([CalendarData(date: endDate, todoData: [todoData])])
                position += 1
                previousDay = day
            } else if day == previousDay {
                sortedTodoDatas[position - 1][0].todoData.append(todoData)
            }
            
            previousDate = endDate
        }
        
        let dayOfMonth = date.getDaysInMonth()
        
        if position < dayOfMonth {
            for numberOfDays in 1..<dayOfMonth - (position - 1) {
                sortedTodoDatas.append([CalendarData(date: previousDate.changeDaysBy(days: numberOfDays),
                                                     todoData: [])])
            }
        }
    }
    
    private func reloadDataAndKeepOffset() {
        // stop scrolling
        pagingCollectionView.setContentOffset(pagingCollectionView.contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = pagingCollectionView.contentSize
        pagingCollectionView.reloadData()
        pagingCollectionView.layoutIfNeeded()
        let afterContentSize = pagingCollectionView.contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: pagingCollectionView.contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: pagingCollectionView.contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        pagingCollectionView.setContentOffset(newOffset, animated: false)
    }
//
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = view.frame.width - 50
//        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
//        let index = Int(round(proportionalOffset))
//        let safeIndex = max(0, min(sortedTodoDatas.count - 1, index))
//        return safeIndex
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexOfCellBeforeDragging = indexOfMajorCell()
//    }
//
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // targetContentOffset: 감속되었을 때 예상 정지 위치
        
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = pagingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = (view.frame.width - 50) + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // 왼쪽 스크롤
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            // 오른쪽 스크롤
            roundedIndex = ceil(index)
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                         y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
    
    private func dismissDayTodoViewController() {
        callback?()
        presentingViewController?.tabBarController?.tabBar.isHidden = false
        dismiss(animated: false)
    }
    
}

extension DayTodoViewController: UICollectionViewDelegate {
}

extension DayTodoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return totalTodoDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "todoListCell",
                                                 for: indexPath)
                as? TodoListCollectionViewCell else {
            return .init()
        }
        
        cell.controller = self
        let day = calendar.component(.day, from: totalTodoDatas[indexPath.item][0].date)
        
//        if day == 1 || day == totalTodoDatas[indexPath.item][0].date.getDaysInMonth() {
//            requestOtherMonth(currentDate: totalTodoDatas[indexPath.item][0].date)
//        }
        
        let dateFormatter = DateFormatter.dateFormatterWithKoreanDay
        let dateString = dateFormatter.string(from: totalTodoDatas[indexPath.item][0].date)
        
        cell.delegate = self
        cell.pushDelegate = self
        cell.dateLabel.text = dateString
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.monthTodoData = totalTodoDatas[indexPath.item][0].todoData
        
        return cell
    }
    
}

extension DayTodoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 50,
                      height: collectionView.frame.height)
    }
}

extension DayTodoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
//        print(indexPaths)
//
//        indexPaths.forEach {
//            guard let cell = pagingCollectionView.cellForItem(at: $0) as? TodoListCollectionViewCell else {
//                return
//            }
//
//            cell.todoListTableView.reloadData()
//        }
    }
}

extension DayTodoViewController: dismissDelegate {
    func touchUpCancelButton() {
        dismissDayTodoViewController()
    }
}

extension DayTodoViewController: PushDelegate {
    func pushViewController(_ controller: UIViewController, _ favoriteButton: UIButton) {
        guard let controller = controller as? DetailInfoViewController else {
            return
        }
        
        controller.callback = { [weak self] isFavorite in
            if isFavorite == 1 {
                favoriteButton.setImage(UIImage(named: "ic_favorite"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "ic_favoritePassive"), for: .normal)
            }
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DayTodoViewController: ChangeTabbarItemDelegate {
    func moveToSwipe() {
        dismiss(animated: false)
        presentingViewController?.tabBarController?.selectedIndex = 1
    }
}
