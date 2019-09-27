//
//  AllPostersListViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 20/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import AdBrixRM

class AllPostersListViewController: UIViewController {
    
    private let categoryList = [1, 0, 4, 7, 5]
    private var posterData: [PosterDataAfterSwpie] = []
    private var currentSortType = 0
    private var currentCategory = 1
    
    private lazy var mypageButton = UIBarButtonItem(image: UIImage(named: "ic_mypage"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(touchUpMypageButton))
    
    private lazy var settingBoardButton = UIBarButtonItem(image: UIImage(named: "bulletin"),
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(touchUpSettingBoardButton))
    
    private let posterService: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 15,
                                                   left: 15,
                                                   bottom: 15,
                                                   right: 15)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var popularOrderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = true
        button.addTarget(self,
                         action: #selector(touchUpOrderButton),
                         for: .touchUpInside)
        button.setImage(UIImage(named: "ic_order"),
                        for: .normal)
        button.setTitle("인기순", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: -8,
                                              bottom: 0,
                                              right: 0)
        return button
    }()
    
    private lazy var deadlineOrderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(touchUpOrderButton),
                         for: .touchUpInside)
        button.setImage(UIImage(named: "ic_orderPassive"),
                        for: .normal)
        button.setTitle("마감일순", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: -8,
                                              bottom: 0,
                                              right: 0)
        return button
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestPosterData()
        tabBarController?.tabBar.isHidden = false
        
        let shadowSize = CGSize(width: self.view.frame.width, height: 3)
        navigationController?.navigationBar.addColorToShadow(color: #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1),
                                                             size: shadowSize)
        
        navigationItem.leftBarButtonItem = mypageButton
        navigationItem.rightBarButtonItem = settingBoardButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupCollectionView()
    }
    
    private func requestPosterData() {
        posterService.requestAllPosterAfterSwipe(category: currentCategory,
                                                 sortType: currentSortType) { [weak self] result in
            switch result {
            case .success(let posterData):
                self?.posterData = posterData
                
                DispatchQueue.main.async {
                    self?.listCollectionView.reloadData()
                    if self?.posterData.count != 0 {
                        self?.listCollectionView.scrollToItem(at: IndexPath(item: 0,
                                                                            section: 0),
                                                              at: .top,
                                                              animated: true)
                    }
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(categoryCollectionView)
        view.addSubview(popularOrderButton)
        view.addSubview(deadlineOrderButton)
        view.addSubview(listCollectionView)
        
        categoryCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryCollectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(
            equalToConstant: 50).isActive = true
        
        popularOrderButton.topAnchor.constraint(
            equalTo: categoryCollectionView.bottomAnchor).isActive = true
        popularOrderButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 28).isActive = true
        popularOrderButton.heightAnchor.constraint(
            equalToConstant: 18).isActive = true
        
        deadlineOrderButton.topAnchor.constraint(
            equalTo: popularOrderButton.topAnchor).isActive = true
        deadlineOrderButton.leadingAnchor.constraint(
            equalTo: popularOrderButton.trailingAnchor,
            constant: 15).isActive = true
        deadlineOrderButton.heightAnchor.constraint(
            equalTo: popularOrderButton.heightAnchor).isActive = true
        
        listCollectionView.topAnchor.constraint(
            equalTo: popularOrderButton.bottomAnchor,
            constant: 10).isActive = true
        listCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 18).isActive = true
        listCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -18).isActive = true
        listCollectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -10).isActive = true
    }
    
    private func setupCollectionView() {
        categoryCollectionView.register(AllPosterCategoryCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "categoryCell")
        
        let allposterNib = UINib(nibName: "AllPosterListCollectionViewCell", bundle: nil)
        
        listCollectionView.register(allposterNib,
                                    forCellWithReuseIdentifier: "allPosterListCell")
    }
    
    func estimatedFrame(text: String,
                        font: UIFont) -> CGRect {
        let size = CGSize(width: 200,
                          height: 1000) // temporary size
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
    
    @objc private func touchUpSettingBoardButton() {
        let storyboard = UIStoryboard(name: StoryBoardName.mypage,
                                      bundle: nil)
        guard let interestVC = storyboard.instantiateViewController(withIdentifier: "InterestBoardVC") as? InterestBoardViewController else {
            return
        }
        
        interestVC.callback = { [weak self] in
            //            self?.requestPoster(isFirst: false)
        }
        
        navigationController?.pushViewController(interestVC, animated: true)
    }
    
    @objc private func touchUpOrderButton() {
        if popularOrderButton.isSelected {
            currentSortType = 1
            requestPosterData()
            popularOrderButton.setImage(UIImage(named: "ic_orderPassive"),
                                        for: .normal)
            deadlineOrderButton.setImage(UIImage(named: "ic_order"),
                                         for: .normal)
        } else {
            currentSortType = 0
            requestPosterData()
            popularOrderButton.setImage(UIImage(named: "ic_order"),
                                        for: .normal)
            deadlineOrderButton.setImage(UIImage(named: "ic_orderPassive"),
                                         for: .normal)
        }
        
        popularOrderButton.isSelected = !popularOrderButton.isSelected
        deadlineOrderButton.isSelected = !deadlineOrderButton.isSelected
    }
}

extension AllPostersListViewController: UICollectionViewDelegate {
    
}

extension AllPostersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 5
        } else {
            return posterData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                     for: indexPath)
                    as? AllPosterCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            switch indexPath.item {
            case 0:
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                
                if let category = PosterCategory(rawValue: categoryList[indexPath.item]) {
                    cell.categoryButton.setTitle(category.categoryString(), for: .normal)
                    cell.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
                    cell.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
                }
            default:
                if let category = PosterCategory(rawValue: categoryList[indexPath.item]) {
                    cell.categoryButton.setTitle(category.categoryString(), for: .normal)
                    cell.categoryButton.setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), for: .normal)
                }
            }
            
            return cell
        } else {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "allPosterListCell",
                                                     for: indexPath)
                    as? AllPosterListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if posterData[indexPath.item].photoUrl == cell.posterData?.photoUrl {
                let imageURL = posterData[indexPath.item].photoUrl ?? ""
                guard let url = URL(string: imageURL) else {
                    return cell
                }
                
                ImageNetworkManager.shared.getImageByCache(imageURL: url){ (image, error) in
                    if error == nil {
                        cell.posterImageView.image = image
                    }
                }
            }
            
            cell.posterData = posterData[indexPath.item]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath)
                as? AllPosterCategoryCollectionViewCell else {
                return
            }
            
            currentCategory = categoryList[indexPath.item]
            requestPosterData()
            
            if let category = PosterCategory(rawValue: categoryList[indexPath.item]) {
                cell.categoryButton.setTitle(category.categoryString(), for: .normal)
                cell.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
                cell.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
            }
        } else {
            let detailInfoVC = DetailInfoViewController()
            
            detailInfoVC.posterIdx = posterData[indexPath.item].posterIdx
            detailInfoVC.isCalendar = false
            
            if let isSave = posterData[indexPath.item].isSave {
                detailInfoVC.isSave = isSave
            }
            
            let adBrix = AdBrixRM.getInstance
            adBrix.event(eventName: "touchUp_PosterDetail",
                         value: ["posterIdx": detailInfoVC.posterIdx])
            
            detailInfoVC.callback = { [weak self] isFavorite in
                DispatchQueue.main.async {
                    let adBrix = AdBrixRM.getInstance
                    adBrix.event(eventName: "touchUp_Favorite")
                }
            }
            
            tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(detailInfoVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath)
                as? AllPosterCategoryCollectionViewCell else {
                    return
            }
            
            if let category = PosterCategory(rawValue: categoryList[indexPath.item]) {
                cell.categoryButton.setTitle(category.categoryString(), for: .normal)
                cell.categoryButton.setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), for: .normal)
                cell.categoryButton.backgroundColor = .clear
            }
        } else {
            
        }
    }
}

extension AllPostersListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            guard let category = PosterCategory(rawValue: categoryList[indexPath.item]) else {
                return CGSize.zero
            }
            
            let width = estimatedFrame(text: category.categoryString(),
                                       font: UIFont.systemFont(ofSize: 13)).width
            
            return CGSize(width: width + 12, height: 21)
        } else {
            return CGSize(width: collectionView.frame.width - 10,
                          height: 100)
        }
    }
}

class AllPosterCategoryCollectionViewCell: UICollectionViewCell {
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 2,
                                              left: 6,
                                              bottom: 2,
                                              right: 6)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryButton)
        
        categoryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
