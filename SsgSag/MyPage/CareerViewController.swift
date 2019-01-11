//
//  CareerViewController.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class CareerViewController: UIViewController {
    
    let activityTableView: UITableView = UITableView()
    let prizeTableView: UITableView = UITableView()
    let certificationTableView: UITableView = UITableView()
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    lazy var activityList: [Datum] = []
    lazy var prizeList: [Datum] = []
    lazy var certificationList: [Datum] = []
    
    
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
        view.backgroundColor = UIColor.rgb(red: 155, green: 65, blue: 250)
        
        //        view.setGradient(from: UIColor.rgb(red: 65, green: 163, blue: 255), to: UIColor.rgb(red: 155, green: 65, blue: 250))
        //        var gradient = CAGradientLayer()
        //        gradient.frame = view.bounds
        //
        //        gradient.colors = [
        //            UIColor.rgb(red: 65, green: 163, blue: 255).cgColor, // Top
        //            UIColor.rgb(red: 155, green: 65, blue: 250).cgColor
        //        ]
        //        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        //        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        //        view.layer.addSublayer(gradient)
        return view
    }()
    
    var customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        
        setUpTableView()
        setTableViewPosition()
        setUpCustomTabBar()
        
        let resNib = UINib(nibName: "ActivityCell", bundle: nil)
        activityTableView.register(resNib, forCellReuseIdentifier: "ActivityCell")
        let prizeNib = UINib(nibName: "PrizeCell", bundle: nil)
        prizeTableView.register(prizeNib, forCellReuseIdentifier: "PrizeCell")
        let certificationNib = UINib(nibName: "CertificationCell", bundle: nil)
        certificationTableView.register(certificationNib, forCellReuseIdentifier: "CertificationCell")
        
        plusButton.addTarget(self, action: #selector(addActivityPresentAction), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getData(careerType: "0")
        getData(careerType: "1")
        getData(careerType: "2")
    }
    
    func setUpCollectionView(){
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
        let backButton = UIBarButtonItem(image: UIImage(named: "icArrowBack"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.dismissModal))
        
        var items = UINavigationItem()
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
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        //        indicatorView.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalToSystemSpacingBelow: customTabBar.bottomAnchor, multiplier: -0.5).isActive = true
        indicatorView.isHidden = false
        indicatorView.setGradient(from: .red, to: .blue)
        
        let bottomLine = UIView()
        customTabBar.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomLine.backgroundColor = UIColor.white
        bottomLine.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalToSystemSpacingBelow: customTabBar.bottomAnchor, multiplier: 0).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            if  scrollView.isDragging  {
                indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 3
            } else {
                indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 3
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
        
        activityTableView.allowsSelection = false
        prizeTableView.allowsSelection = false
        certificationTableView.allowsSelection = false
        
        activityTableView.tableFooterView = UIView()
        prizeTableView.tableFooterView = UIView()
        certificationTableView.tableFooterView = UIView()
        
        activityTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        prizeTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        certificationTableView.backgroundColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        activityTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        prizeTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
        certificationTableView.separatorColor = UIColor.rgb(red: 242, green: 243, blue: 245)
    }
    
    func setUpEmptyTableView(tableView: UITableView, isEmptyTable: Bool) {
        print("몇번")
        let emptyImageView = UIImageView()
        view.addSubview(emptyImageView)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        //emptyImageView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 122).isActive = true
        //emptyImageView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 50).isActive = true
        //emptyImageView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 50).isActive = true
        emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImageView.heightAnchor.constraint(equalToConstant: 276).isActive = true
        emptyImageView.image = UIImage(named: "imgEmptyCareer")
        
        //            let emptyLabel = UILabel()
        //            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        //            emptyLabel.text = "어떤 활동을 했는지\n기록해보세요!"
        //            emptyLabel.numberOfLines = 2
        //            emptyLabel.textColor = UIColor.rgb(red: 155, green: 155, blue: 155)
        //            emptyLabel.font = UIFont.systemFont(ofSize: 19)
        //            emptyLabel.textAlignment = .center
        //            tableView.addSubview(emptyLabel)
        //            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 43).isActive = true
        //            emptyLabel.centerXAnchor.constraint(equalTo: emptyImageView.centerXAnchor).isActive = true
        //
        
        if isEmptyTable {
            emptyImageView.isHidden = false
            //emptyLabel.isHidden = false
        } else {
            print("숨겨")
            emptyImageView.isHidden = false
            //emptyLabel.isHidden = true
            //tableView.sendSubviewToBack(emptyLabel)
            view.sendSubviewToBack(emptyImageView)
        }
        
    }
    
}

extension CareerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bottomLine = UIView()
        customTabBar.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomLine.backgroundColor = UIColor.white
        bottomLine.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalToSystemSpacingBelow: customTabBar.bottomAnchor, multiplier: 0).isActive = true
        
        switch tableView {
        case activityTableView:
            if activityList.count > 0 {
                return activityList.count
            } else {
                print("asldjlasjdlajsldkjalsjdklajslkdjasl: \(activityList.count)")
                //                setUpEmptyTableView(tableView: activityTableView, isEmptyTable: true)
                return activityList.count
            }
        case prizeTableView:
            if prizeList.count == 0 {
                print("2번째 비어있음: \(prizeList.count)")
                //                setUpEmptyTableView(tableView: prizeTableView, isEmptyTable: true)
                return prizeList.count
            } else { return prizeList.count }
        case certificationTableView:
            if certificationList.count == 0 {
                //                setUpEmptyTableView(tableView: certificationTableView)
                return certificationList.count
            } else { return certificationList.count }
        default : return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == activityTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            let activity: Datum = self.activityList[indexPath.row]
            cell.titleLabel.text = activity.careerName
            cell.dateLabel1.text = activity.careerDate1
            if activity.careerDate2 != "" {
                cell.dateLabel2.text = "~ " + activity.careerDate2
            }
            cell.detailLabel.text = activity.careerContent
            cell.selectionStyle = .none
            return cell
        } else if tableView == prizeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeCell", for: indexPath) as! ActivityCell
            let prize: Datum = self.prizeList[indexPath.row]
            cell.titleLabel.text = prize.careerName
            cell.dateLabel1.text = prize.careerDate1
            cell.detailLabel.text = prize.careerContent
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationCell", for: indexPath) as! ActivityCell
            //            cell.titleLabel.text = certificationList[indexPath.row].title
            //            cell.periodLabel.text = certificationList[indexPath.row].date
            //            cell.detailLabel.text = certificationList[indexPath.row].content
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension CareerViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCareerCell", for: indexPath) as! CustomCareerCell
        if indexPath.row == 0 {
            cell.label.textColor = .black
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        switch indexPath.row {
        case 0 : cell.label.text = "대외활동"
        case 1 : cell.label.text = "수상내역"
        case 2 : cell.label.text = "자격증"
        default: break
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3 , height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCareerCell else {return}
        cell.label.textColor = .black
        indicatorViewLeadingConstraint.constant = (self.view.frame.width / 3) * CGFloat((indexPath.row))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.customTabBar.layoutIfNeeded()
        }, completion: nil)
        
        let myPageStoryBoard = UIStoryboard(name: "MyPageStoryBoard", bundle: nil)
        let addVC = myPageStoryBoard.instantiateViewController(withIdentifier: "AddVC") as! AddVC
        
        if indexPath.row == 0 {
            if plusButton.target(forAction: #selector(addPresentAction), withSender: nil) != nil{
                plusButton.removeTarget(self, action: #selector(addPresentAction), for: .touchUpInside)
            }
            plusButton.addTarget(self, action: #selector(addActivityPresentAction), for: .touchUpInside)
        }else if indexPath.row == 1{
            if plusButton.target(forAction: #selector(addActivityPresentAction), withSender: nil) != nil{
                plusButton.removeTarget(self, action: #selector(addActivityPresentAction), for: .touchUpInside)
            }
            plusButton.addTarget(self, action: #selector(addPresentAction), for: .touchUpInside)
            
        }else {
            if plusButton.target(forAction: #selector(addActivityPresentAction), withSender: nil) != nil{
                plusButton.removeTarget(self, action: #selector(addActivityPresentAction), for: .touchUpInside)
            }
            plusButton.addTarget(self, action: #selector(addPresentAction), for: .touchUpInside)
        }
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.scrollView.contentOffset.x = self.view.frame.width * CGFloat(indexPath.row)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCareerCell else {return}
        cell.label.textColor = .lightGray
    }
    
    @objc func addActivityPresentAction() {
        if let activityVC = storyboard?.instantiateViewController(withIdentifier: "AddActivityVC")
        {
            present(activityVC, animated: true)
        }
    }
    
    @objc func addPresentAction() {
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") {
            present(addVC, animated: true)
        }
    }
    
    //
    func getData(careerType: String) {
        let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://54.180.79.158:8080/career/info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            guard let data = data else { return }
            
            print(data)
            print("gggg")
            print(response)
            
            do {
                let apiResponse = try JSONDecoder().decode(Career.self, from: data)
                print("orders: \(apiResponse)")
                if careerType == "0" {
                    print("00000000")
                    self.activityList = apiResponse.data
                    DispatchQueue.main.async {
                        self.activityTableView.reloadData()
                    }
                } else if careerType == "1" {
                    print("111111111")
                    self.prizeList = apiResponse.data
                    DispatchQueue.main.async {
                        self.prizeTableView.reloadData()
                    }
                } else if careerType == "2" {
                    self.certificationList = apiResponse.data
                    DispatchQueue.main.async {
                        self.certificationTableView.reloadData()
                    }
                }
                
            } catch (let err) {
                print(err.localizedDescription)
                print("sladjalsdjlasjdlasjdlajsldjas")
            }
            
            //            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            //            if let responseJSON = responseJSON as? [String: Any] {
            //                //print("responseJSON \(responseJSON)")
            //                //print(responseJSON["data"])
            //                var a = responseJSON["data"]
            //                print(a)
            //                print("1")
            //            }
        }
        task.resume()
    }
}

