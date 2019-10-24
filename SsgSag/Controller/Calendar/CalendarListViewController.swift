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
        return button
    }()
    
    private lazy var calendarEtcBarButton
        = UIBarButtonItem(customView: calendarEtcButton)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = mypageButton
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
                    self?.posterImageTasks.append(dataTask)
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
        // 삭제
    }
}

// scroll
extension CalendarListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != categoryCollectionView else {
            return
        }
        
        if scrollView.contentSize.width != 0 {
            if currentScrollContentHeight != scrollView.contentSize.width {
                if scrollView.contentOffset.y + listCollectionView.frame.height > scrollView.contentSize.height * 0.8 {
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
                    
                    requestTodoData(year: year, month: month)
                    currentScrollContentHeight = scrollView.contentSize.width
                }
            }
        }
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
