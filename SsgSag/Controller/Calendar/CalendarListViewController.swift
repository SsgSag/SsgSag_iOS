//
//  CalendarListViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 21/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarListViewController: UIViewController {

    var year: Int?
    var month: Int?
    
    private var todoData: [MonthTodoData] = []
    private var posterImageTasks: [URLSessionDataTask] = []
    
    private let downloadLink = "https://ssgsag.page.link/install"
    private let imageCache = NSCache<NSString, UIImage>()
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30,
                                 height: 90)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 30)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 15,
                                                   left: 0,
                                                   bottom: 15,
                                                   right: 0)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
                                             [0,1,2,4,7,8],
                                             favorite: 0) { [weak self] result in
            switch result {
            case .success(let monthTodoData):
                self?.todoData = monthTodoData
                
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
                    
                    self?.posterImageTasks.append(dataTask)
                }
                
                DispatchQueue.main.async {
                    self?.listCollectionView.reloadData()
                }
            case .failed:
                return
            }
        }
    }
    
    private func setupCollectionView() {
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
            equalToConstant: 30).isActive = true
        
        listCollectionView.topAnchor.constraint(
            equalTo: categoryCollectionView.bottomAnchor).isActive = true
        listCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        listCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        listCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
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
        // 공유하기
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
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
        
//        addObjects(with: objectsToshare)
    }
}

extension CalendarListViewController: UICollectionViewDelegate {
    
}

extension CalendarListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == listCollectionView {
            return todoData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listCollectionView {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell",
                                                     for: indexPath)
                    as? CalendarListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.todoData = todoData[indexPath.item]
            
            if todoData[indexPath.item].thumbPhotoUrl == cell.todoData?.thumbPhotoUrl {
                guard let urlString = todoData[indexPath.item].thumbPhotoUrl else {
                    return cell
                }
                
                if imageCache.object(forKey: urlString as NSString) == nil {
                    if let imageURL = URL(string: urlString) {
                        
                        URLSession.shared.dataTask(with: imageURL) { data, response, error in
                            guard error == nil,
                                let data = data,
                                let image = UIImage(data: data) else {
                                    return
                            }
                            
                            DispatchQueue.main.async {
                                cell.posterImageView.image = image
                            }
                        }.resume()
                    }
                    return cell
                }
                
                cell.posterImageView.image = imageCache.object(forKey: urlString as NSString)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == listCollectionView {
            if todoData.count == 0 {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            guard let header
                = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "dateSeperateHeader",
                                                                  for: indexPath)
                    as? ListDateSperateCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            header.dateLabel.text = todoData[indexPath.item].posterEndDate
            
            return header
        }
        return UICollectionReusableView()
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
