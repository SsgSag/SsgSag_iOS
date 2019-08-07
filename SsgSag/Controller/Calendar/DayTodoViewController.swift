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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        return collectionView
    }()
    
    var currentDate: Date?
    private var todoDatas: [MonthTodoData] = []
    private var sortedTodoDatas: [[MonthTodoData]] = []
    private var totalTodoDatas: [[MonthTodoData]] = []
    var mutableData = [MonthTodoData]()
    var dataPointer = 0
    
    private let calendar = Calendar.current
    private let calendarServiceImp: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    lazy var layout = self.pagingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    private var indexOfCellBeforeDragging = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4656999144)
        
        requestData(right: true)
        setupLayout()
        setupCollectionView()
        pagingCollectionView.prefetchDataSource = self
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
    
    private func requestData(right: Bool) {
        guard let date = currentDate else { return }
        
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        
        calendarServiceImp.requestMonthTodoList(year: year, month: month) { [weak self] dataResponse in
            switch dataResponse {
            case .success(let todoData):
                self?.todoDatas = todoData
                DispatchQueue.main.async {
                    self?.makeSortedTodoDatas()
                    self?.sortedTodoDatas.forEach {
                        self?.totalTodoDatas.append($0)
                    }
                    
                    self?.mutableData = self?.totalTodoDatas[self?.dataPointer ?? 0] ?? []
                    
                    if right {
                        self?.pagingCollectionView.reloadData()
                    } else {
                        self?.reloadDataAndKeepOffset()
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
    
    private func makeSortedTodoDatas() {
        guard let currentDate = currentDate else { return }
        let currentDay = calendar.component(.day, from: currentDate)
        
        var position = 0
        var previousDay = currentDay - 1
        
        
        for (_, todoData) in todoDatas.enumerated() {
            guard let posterEndDate = todoData.posterEndDate else { return }
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: posterEndDate)
            let day = calendar.component(.day, from: endDate)
            
            if day < currentDay {
                continue
            }
            
            if previousDay != day {
                for _ in previousDay..<(day - 1) {
                    sortedTodoDatas.append([])
                    position += 1
                }
            }
            
            if day > previousDay {
                sortedTodoDatas.append([todoData])
                position += 1
                previousDay = day
            } else if day == previousDay {
                sortedTodoDatas[position - 1].append(todoData)
            }
        }
        
        let dayOfMonth = currentDate.getDaysInMonth()
        
        if position < dayOfMonth - currentDay {
            for _ in position..<dayOfMonth - currentDay {
                sortedTodoDatas.append([])
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
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = view.frame.width - 50
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(sortedTodoDatas.count - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        // targetContentOffset : 스크롤 속도가 줄어들어 정지될 때 예상되는 위치
        targetContentOffset.pointee = scrollView.contentOffset

        // endDragging 했을 때 index
        let indexOfMajorCell = self.indexOfMajorCell()

        // swipe 시킬 속도
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        
        let hasEnoughVelocityToSlideToTheNextCell
            = indexOfCellBeforeDragging + 1 < sortedTodoDatas.count
                && velocity.x > swipeVelocityThreshold
        
        let hasEnoughVelocityToSlideToThePreviousCell
            = indexOfCellBeforeDragging - 1 >= 0
                && velocity.x < -swipeVelocityThreshold
        
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        
        // 스와이프 했는지 여부
        let didUseSwipeToSkipCell
            = majorCellIsTheCellBeforeDragging
                && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        let didSwipeToRight = indexOfMajorCell > indexOfCellBeforeDragging
        
        var indexPath = IndexPath()
        
        if didUseSwipeToSkipCell {
            
            if hasEnoughVelocityToSlideToTheNextCell {
                indexPath = IndexPath(row: indexOfMajorCell + 1, section: 0)
                pagingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            } else {
                indexPath = IndexPath(row: indexOfMajorCell - 1, section: 0)
                pagingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        } else {
            indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            
            pagingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
//        guard let currentIndexPath
//            = pagingCollectionView.indexPathForItem(at: CGPoint(x: view.frame.midX + scrollView.contentOffset.x,
//                                                                y: view.frame.midY)) else {
//                                                                    return
//        }
//
//        dataPointer = currentIndexPath.item
//
//        print(dataPointer)
//
//        mutableData = totalTodoDatas[dataPointer]

        guard let cell = pagingCollectionView.cellForItem(at: indexPath) as? TodoListCollectionViewCell else {
            return
        }
        
        mutableData = totalTodoDatas[indexPath.item]

        cell.todoListTableView.reloadData()
        
    }
    
}

extension DayTodoViewController: UICollectionViewDelegate {
}

extension DayTodoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sortedTodoDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "todoListCell",
                                                 for: indexPath)
                as? TodoListCollectionViewCell else {
            return .init()
        }
        
        let cellDate = currentDate?.changeDaysBy(days: indexPath.item)
        let dateFormatter = DateFormatter.dateFormatterWithKoreanDay
        let dateString = dateFormatter.string(from: cellDate ?? Date())
        
        cell.dateLabel.text = dateString
        
        cell.delegate = self
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.todoListTableView.delegate = self
        cell.todoListTableView.dataSource = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        print(indexPaths)
        
        indexPaths.forEach {
            guard let cell = pagingCollectionView.cellForItem(at: $0) as? TodoListCollectionViewCell else {
                return
            }
            
            mutableData = totalTodoDatas[$0.item]
            
            cell.todoListTableView.reloadData()
        }
        
    }
}

extension DayTodoViewController: dismissDelegate {
    func touchUpCancelButton() {
        presentingViewController?.tabBarController?.tabBar.isHidden = false
        dismiss(animated: false)
    }
}

extension DayTodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

extension DayTodoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return mutableData.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell
            = tableView.dequeueReusableCell(withIdentifier: "todoCell",
                                            for: indexPath)
                as? DetailTodoListTableViewCell else {
                    return .init()
        }
        
        cell.selectionStyle = .none
        cell.poster = mutableData[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let detailInfoVC = DetailInfoViewController()
        
        detailInfoVC.posterIdx = mutableData[indexPath.row].posterIdx
        
        navigationController?.pushViewController(detailInfoVC,
                                                 animated: true)
    }

}
