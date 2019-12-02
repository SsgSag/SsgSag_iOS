//
//  CalendarListViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 21/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import AdBrixRM

class CalendarListViewController: UIViewController {

    // 오늘 기준 날짜
    var currentYear: Int?
    var currentMonth: Int?
    
    var year: Int?
    var month: Int?
    
    private var todoData: [[MonthTodoData]] = []
    private var posterImageTasks: [URLSessionDataTask] = []
    private var currentScrollContentHeight: CGFloat = 0
    private var networkCategoryList = [0, 1, 4, 7, 5]
    private var isFavorite = 0
    private var isDeleting: Bool = false
    private var isNetworking: Bool = false
    private var deleteIndexPaths: [IndexPath] = []
    private var deletePosterIndexs: [Int] = []
    
    private let category = ["전체", "즐겨찾기", "공모전", "대외활동", "인턴", "교육/강연", "기타"]
    private let downloadLink = "https://ssgsag.page.link/install"
    private let imageCache = NSCache<NSString, UIImage>()
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    private var listDataSource: ListCollectionViewDataSource?
    
    private var categoryDataSourece: CategoryCollectionViewDataSourece? {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 25,
                                                   bottom: 5,
                                                   right: 25)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width,
                                            height: 48)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: -10,
                                                   left: 0,
                                                   bottom: 10,
                                                   right: 0)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var mypageButton = UIBarButtonItem(image: UIImage(named: "ic_mypage"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(touchUpMypageButton))
    
    private lazy var calendarSwitchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(touchUpCalendarSwitchButton(_:)),
                         for: .touchUpInside)
        button.setImage(UIImage(named: "ic_switchToCalendar"), for: .normal)
        return button
    }()
    
    private lazy var calendarSwitchBarButton
        = UIBarButtonItem(customView: calendarSwitchButton)
    
    
    private lazy var calendarEtcButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(touchUpCalendarEtcButton(_:)),
                         for: .touchUpInside)
        button.setImage(UIImage(named: "ic_modify"), for: .normal)
        button.setTitleColor(UIColor(red: 98/255.0 , green: 106/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var calendarEtcBarButton
        = UIBarButtonItem(customView: calendarEtcButton)
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        guard let year = year,
            let month = month else {
            return label
        }
        
        label.text = "\(year)년 \(month)월"
        label.font = .systemFont(ofSize: 20,
                                 weight: .semibold)
        label.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        return label
    }()
    
    private lazy var dateHeaderBarItem = UIBarButtonItem(customView: self.dateLabel)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItems = [mypageButton, dateHeaderBarItem]
        navigationItem.rightBarButtonItems = [calendarEtcBarButton, calendarSwitchBarButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        year = currentYear
        month = currentMonth
        requestTodoData(year: year, month: month)
        setupCollectionView()
        setupLayout()
    }
    
    private func requestTodoData(year: Int?, month: Int?) {
        guard let year = year,
            let month = month else {
            return
        }
        
        calendarService.requestMonthTodoList(year: String(year),
                                             month: String(month),
                                             networkCategoryList,
                                             favorite: isFavorite) { [weak self] result in
            switch result {
            case .success(let monthTodoData):
                if self?.currentYear == year && self?.currentMonth == month {
                    self?.todoData = []
                }

                self?.classifyMonthToData(monthTodoData)
                
                for data in monthTodoData {
                    guard let urlString = data.thumbPhotoUrl,
                        let imageURL = URL(string: urlString) else {
                            continue
                    }
                    
                    let dataTask
                        = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                            guard error == nil,
                                let data = data,
                                let image = UIImage(data: data) else {
                                    return
                            }
                            
                            self?.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                    dataTask.resume()
                    self?.posterImageTasks.append(dataTask as! URLSessionDataTask)
                }
                
                DispatchQueue.main.async {
                    guard let todoData = self?.todoData,
                        let imageCache = self?.imageCache else {
                        return
                    }
                    
                    self?.listDataSource
                        = ListCollectionViewDataSource(todoData,
                                                       cache: imageCache)
                    self?.listCollectionView.dataSource = self?.listDataSource
                    self?.listDataSource?.controller = self
                    self?.listCollectionView.reloadData()
                    
                    if let attributes =
                        self?.listCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(
                            ofKind: UICollectionView.elementKindSectionHeader,
                            at: IndexPath(item: 0, section: 0)) {
                    self?.listCollectionView.setContentOffset(
                        CGPoint(x: 0,
                                y: attributes.frame.origin.y
                                    - (self?.listCollectionView.contentInset.top)!),
                        animated: false)
                    }
                    
                    self?.isNetworking = false
                }
            case .failed:
                return
            }
        }
    }
    
    private func setupCollectionView() {
        categoryDataSourece = CategoryCollectionViewDataSourece()
        categoryCollectionView.dataSource = categoryDataSourece
        
        categoryCollectionView.dataSource = categoryDataSourece
        
        categoryCollectionView.register(CategoryHeaderCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "categoryHeaderCell")
        
        categoryCollectionView.register(CategoryCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "categoryCell")
        
        let dateSeperateNib = UINib(nibName: "ListDateSperateCollectionReusableView",
                                    bundle: nil)
        listCollectionView.register(dateSeperateNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "dateSeperateHeader")
        
        listCollectionView.register(TempCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "tempHeader")
        
        let listNib = UINib(nibName: "CalendarListCollectionViewCell",
                            bundle: nil)
        listCollectionView.register(listNib,
                                    forCellWithReuseIdentifier: "listCell")
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(categoryCollectionView)
        view.addSubview(listCollectionView)
        
        categoryCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(
            equalToConstant: 33).isActive = true
        
        listCollectionView.topAnchor.constraint(
            equalTo: categoryCollectionView.bottomAnchor).isActive = true
        listCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        listCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        listCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
    }
    
    private func classifyMonthToData(_ todoData: [MonthTodoData]) {
        var todoDataOfDay: [MonthTodoData] = []
        var beforeDday = -1
        
        for (index, todo) in todoData.enumerated() {
            if todo.dday == -1 || todo.dday == nil {
                continue
            }
            
            if beforeDday != todo.dday {
                if todoDataOfDay.count != 0 {
                    self.todoData.append(todoDataOfDay)
                }
                todoDataOfDay = [todo]
                
                beforeDday = todo.dday!
            } else {
                todoDataOfDay.append(todo)
            }

            if index == todoData.endIndex - 1 {
                self.todoData.append(todoDataOfDay)
            }
            
        }
    }
    
    private func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    @objc private func touchUpMypageButton() {
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        present(myPageViewNavigator,
                animated: true)
    }
    
    @objc private func touchUpCalendarSwitchButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @objc private func touchUpCalendarEtcButton(_ sender: UIButton) {
        if calendarEtcButton.titleLabel?.text == "삭제" && deleteIndexPaths.count != 0 {
            // 삭제
            
            simpleAlertwithHandler(title: "",
                                   message: "\(deleteIndexPaths.count)개의 일정을 삭제하시겠어요?") { [weak self] _ in
                guard let self = self else {
                    return
                }
                                                
                self.deleteIndexPaths.sort()
                                                
                self.calendarService.requestTodoDelete(self.deletePosterIndexs) { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(let status):
                        DispatchQueue.main.async {
                            switch status {
                            case .processingSuccess:
                                var count = 0
                                self.deleteIndexPaths.forEach {
                                    self.todoData[$0.section].remove(at: $0.item - count)
                                    if self.todoData[$0.section].count == 0 {
                                        self.todoData.remove(at: $0.section)
                                    }
                                    count += 1
                                }
                                self.listCollectionView.deleteItems(at: self.deleteIndexPaths)
                                self.deleteIndexPaths = []
                                self.listDataSource?.todoData = self.todoData
                                self.listCollectionView.reloadData()
                            case .dataBaseError:
                                print("DB 에러")
                                return
                            case .serverError:
                                print("서버 에러")
                                return
                            default:
                                return
                            }
                        }
                    case .failed(let error):
                        print(error)
                        return
                    }
                }
            }
        }
        
        if calendarEtcButton.imageView?.image == UIImage(named: "ic_back") {
            calendarEtcButton.setImage(UIImage(named: "ic_modify"), for: .normal)
            calendarEtcButton.setTitle(nil, for: .normal)
            calendarSwitchButton.setImage(UIImage(named: "ic_switchToCalendar"), for: .normal)
            listDataSource?.isDeleting = false
            isDeleting = false
            listCollectionView.reloadData()
            return
        }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "편집",
                                        style: .default) { [weak self] (action) in
            self?.calendarEtcButton.setImage(UIImage(named: "ic_back"),
                                             for: .normal)
            self?.calendarSwitchButton.setImage(nil,
                                                for: .normal)
            
            self?.isDeleting = true
            self?.listDataSource?.isDeleting = true
            self?.listCollectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true)
        
    }
}

// scroll
extension CalendarListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isNetworking else {
            return
        }
        
        guard scrollView != categoryCollectionView else {
            return
        }
        
        if scrollView.contentSize.height != 0 {
            if currentScrollContentHeight != scrollView.contentSize.height {
                if scrollView.contentOffset.y + listCollectionView.frame.height >= scrollView.contentSize.height {
                    guard var year = year,
                        var month = month else {
                        return
                    }
                    
                    if month == 12 {
                        year += 1
                        month = 1
                    } else {
                        month += 1
                    }
                    
                    isNetworking = true
                    
                    requestTodoData(year: year, month: month)
                    currentScrollContentHeight = scrollView.contentSize.height
                    self.year = year
                    self.month = month
                }
            }
        }
        
        print(listCollectionView.indexPathForItem(at: CGPoint(x: listCollectionView.frame.width / 2, y: listCollectionView.contentOffset.y)))
        
        guard let indexPathForItem
            = listCollectionView.indexPathForItem(at: CGPoint(x: listCollectionView.frame.width / 2,
                                                              y: listCollectionView.contentOffset.y)) else {
            return
        }
        
        guard let cell
            = listCollectionView.cellForItem(at: indexPathForItem)
                as? CalendarListCollectionViewCell else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let posterEndDate = cell.todoData?.posterEndDate,
            let date = dateFormatter.date(from: posterEndDate) else {
            return
        }
        
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        dateLabel.text = "\(year)년 \(month)월"
        
    }
}

extension CalendarListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            switch indexPath.item {
            case 0, 1:
                guard let cell
                    = categoryCollectionView.cellForItem(at: indexPath)
                        as? CategoryHeaderCollectionViewCell else {
                    return
                }
                
                cell.didSelectedCell()
                
                networkCategoryList = [0, 1, 4, 7, 5]
            default:
                guard let cell
                    = categoryCollectionView.cellForItem(at: indexPath)
                        as? CategoryCollectionViewCell else {
                    return
                }
                
                networkCategoryList = cell.didSelectedCell(index: indexPath.item)
            }

            isFavorite = indexPath.item == 1 ? 1 : 0
            
            requestTodoData(year: currentYear, month: currentMonth)
        } else {
            guard !isDeleting else {
                return
            }
            
            let posterIdx = todoData[indexPath.section][indexPath.item].posterIdx
            let detailInfoViewController = DetailInfoViewController()
            
            detailInfoViewController.posterIdx = posterIdx
            
            let adBrix = AdBrixRM.getInstance
            adBrix.event(eventName: "touchUp_PosterDetail",
                         value: ["posterIdx": posterIdx])
            
            detailInfoViewController.callback = { [weak self] isFavorite in
                let adBrix = AdBrixRM.getInstance
                adBrix.event(eventName: "touchUp_Favorite")
                
                guard let cell
                    = self?.listCollectionView.cellForItem(at: indexPath)
                        as? CalendarListCollectionViewCell else {
                    return
                }
                
                let imageName
                    = isFavorite == 1 ? "ic_favorite" : "ic_favoritePassvie"
                
                cell.favoriteButton.setImage(UIImage(named: imageName),
                                             for: .normal)
            }
            
            navigationController?.pushViewController(detailInfoViewController,
                                                     animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            switch indexPath.item {
            case 0, 1:
                guard let cell
                    = categoryCollectionView.cellForItem(at: indexPath)
                        as? CategoryHeaderCollectionViewCell else {
                    return
                }
                
                cell.didDeselectedCell()
            default:
                guard let cell
                    = categoryCollectionView.cellForItem(at: indexPath)
                        as? CategoryCollectionViewCell else {
                    return
                }
                
                cell.didDeselectedCell()
            }
        }
    }
}

extension CalendarListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            posterImageTasks[$0.item].resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            
            posterImageTasks[$0.item].cancel()
        }
    }
}

extension CalendarListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let collectionViewCellWidth = estimatedFrame(text: category[indexPath.item],
                                                         font: UIFont.systemFont(ofSize: 15)).width
            
            return CGSize(width: collectionViewCellWidth + 5,
                          height: 20)
        }
        
        return CGSize(width: view.frame.width - 30,
                      height: 90)
    }
}

extension CalendarListViewController: TodoDeleteDelegate {
    func selectedTodo(_ posterIdx: Int, indexPath: IndexPath) {
        if deleteIndexPaths.count == 0 {
            calendarEtcButton.setImage(nil, for: .normal)
            calendarEtcButton.setTitle("삭제", for: .normal)
        }
        deletePosterIndexs.append(posterIdx)
        deleteIndexPaths.append(indexPath)
    }
    
    func deselectedTodo(_ posterIdx: Int, indexPath: IndexPath) {
        var index = 0
        
        for deleteIndexPath in deleteIndexPaths {
            if indexPath == deleteIndexPath {
                deleteIndexPaths.remove(at: index)
                deletePosterIndexs.remove(at: index)
                if deleteIndexPaths.count == 0 {
                    calendarEtcButton.setImage(#imageLiteral(resourceName: "ic_editBack"), for: .normal)
                    calendarEtcButton.setTitle("", for: .normal)
                }
                return
            }
            index += 1
        }
    }
}
