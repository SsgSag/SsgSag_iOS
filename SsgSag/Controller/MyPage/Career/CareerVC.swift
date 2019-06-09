//
//  CareerViewController.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class CareerVC: UIViewController {
    
    let activityTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    let prizeTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    let certificationTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    lazy var activityList: [careerData] = []
    lazy var prizeList: [careerData] = []
    lazy var certificationList: [careerData] = []
    
    private var latestContentOffsetX: CGFloat = 0
    
    var careerServiceImp: CareerService!
    
    var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 60), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setService()
        
        setupScrollView()
        
        setUpTableView()
        
        setTableViewPosition()
        
        setUpCustomTabBar()
        
        setupTablViewRegister()
        
        setupActivityDelegate()
    }
    
    func setService(_ service:CareerService = CareerServiceImp()) {
        self.careerServiceImp = service
    }
    
    private func setupActivityDelegate() {
        
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupTablViewRegister() {
        
        let activityNib = UINib(nibName: "ActivityCell", bundle: nil)
        activityTableView.register(activityNib, forCellReuseIdentifier: "ActivityCell")
        
        let prizeNib = UINib(nibName: "PrizeCell", bundle: nil)
        prizeTableView.register(prizeNib, forCellReuseIdentifier: "PrizeCell")
        
        let certificationNib = UINib(nibName: "CertificationCell", bundle: nil)
        certificationTableView.register(certificationNib, forCellReuseIdentifier: "CertificationCell")
    }
    
    private func setUpCollectionView(){
        
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.backgroundColor = .white
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        
        let customNib = UINib(nibName: "CustomCareerCell", bundle: nil)
        customTabBarCollectionView.register(customNib, forCellWithReuseIdentifier: "CustomCareerCell")
        customTabBarCollectionView.isScrollEnabled = false
    }
    
    @objc func dismissModal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpCustomTabBar(){
        setUpCollectionView()
        
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationBar)
        
        navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 60).isActive = true
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icArrowBack"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.dismissModal))
        
        let items = UINavigationItem()
        items.leftBarButtonItem = backButton
        items.title = "이력"
        backButton.tintColor = .black
        navigationBar.items?.append(items)
        navigationBar.barTintColor = .white
        
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.title = "이력"
        
        self.view.addSubview(customTabBar)
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customTabBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        customTabBar.addSubview(customTabBarCollectionView)
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: customTabBar.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        customTabBar.addSubview(indicatorView)
        indicatorView.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalToSystemSpacingBelow: customTabBar.bottomAnchor, multiplier: -0.5).isActive = true
        indicatorView.isHidden = false
        
        let color1 = UIColor.rgb(red: 155, green: 65, blue: 250)
        let color2 = UIColor.rgb(red: 65, green: 163, blue: 255)
       
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width/3, height: 3)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        indicatorView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x != latestContentOffsetX {
            if scrollView == scrollView {
                if  scrollView.isDragging  {
                    indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 3
                } else {
                    indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 3
                }
            }
        }
    }


    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView.contentOffset.x != latestContentOffsetX {
            if scrollView == scrollView {
                let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
                let index = IndexPath(item: itemAt, section: 0)
                switch itemAt {
                case 0:
                    let cell = customTabBarCollectionView.cellForItem(at: index) as? CustomCareerCell
                    cell?.label.textColor = .black
                    let cell1 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CustomCareerCell
                    cell1?.label.textColor = .lightGray
                    let cell2 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? CustomCareerCell
                    cell2?.label.textColor = .lightGray
                case 1:
                    let cell = customTabBarCollectionView.cellForItem(at: index) as? CustomCareerCell
                    cell?.label.textColor = .black
                    let cell1 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CustomCareerCell
                    cell1?.label.textColor = .lightGray
                    let cell2 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? CustomCareerCell
                    cell2?.label.textColor = .lightGray
                case 2:
                    let cell = customTabBarCollectionView.cellForItem(at: index) as? CustomCareerCell
                    cell?.label.textColor = .black
                    let cell1 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CustomCareerCell
                    cell1?.label.textColor = .lightGray
                    let cell2 = customTabBarCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CustomCareerCell
                    cell2?.label.textColor = .lightGray
                default: break
                }
            }
        }
    }
    
    func setTableViewPosition() {
        scrollView.contentSize.width = self.view.frame.width * CGFloat(3)
        
        scrollView.addSubview(activityTableView)
        scrollView.addSubview(prizeTableView)
        scrollView.addSubview(certificationTableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        activityTableView.translatesAutoresizingMaskIntoConstraints = false
        prizeTableView.translatesAutoresizingMaskIntoConstraints = false
        certificationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            activityTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            prizeTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            certificationTableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            activityTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            prizeTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            certificationTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            
            activityTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            activityTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            activityTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            activityTableView.trailingAnchor.constraint(equalTo: prizeTableView.leadingAnchor),
            
            prizeTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            prizeTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            prizeTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            prizeTableView.trailingAnchor.constraint(equalTo: certificationTableView.leadingAnchor),
            
            certificationTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            certificationTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            certificationTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            certificationTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            ])
    }
    
    func setUpTableView() {
        activityTableView.delegate = self
        activityTableView.dataSource = self
        
        prizeTableView.delegate = self
        prizeTableView.dataSource = self
        
        certificationTableView.delegate = self
        certificationTableView.dataSource = self
        
        activityTableView.showsVerticalScrollIndicator = false
        prizeTableView.showsVerticalScrollIndicator = false
        certificationTableView.showsVerticalScrollIndicator = false
        
        activityTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        prizeTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        certificationTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        
        activityTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        prizeTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        certificationTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        
    }
    
    func setUpEmptyTableView(tableView: UITableView, isEmptyTable: Bool) {
        let emptyImageView = UIImageView()
        view.addSubview(emptyImageView)
        
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImageView.heightAnchor.constraint(equalToConstant: 276).isActive = true
        emptyImageView.image = UIImage(named: "imgEmptyCareer")
        
        if isEmptyTable {
            
            emptyImageView.isHidden = false
            
        } else {
            
            emptyImageView.isHidden = false
            view.sendSubviewToBack(emptyImageView)
        }
    }
    
    func getData(careerType: Int) {
        
        careerServiceImp.requestCareer(careerType: careerType) { dataResponse in
            guard let careerData = dataResponse.value else {return}
            
            DispatchQueue.main.async { [weak self] in
                
                if careerType == 0 {
                    
                    self?.activityList = careerData.data
                    self?.activityTableView.reloadData()
                    
                } else if careerType == 1 {
                    
                    self?.prizeList = careerData.data
                    self?.prizeTableView.reloadData()
                    
                } else if careerType == 2 {
                    
                    self?.certificationList = careerData.data
                    self?.certificationTableView.reloadData()
                    
                }
                
            }
            
        }
    }
    
}
