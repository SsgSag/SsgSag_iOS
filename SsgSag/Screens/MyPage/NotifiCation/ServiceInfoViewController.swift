//
//  ServiceInfoViewController.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ServiceInfoViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ServiceInfoTableViewCell.self,
                           forCellReuseIdentifier: ServiceInfoViewController.cellId)
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset.left = 0
        return tableView
    }()
    
    static private let numberOfRows = 4
    
    static private let cellId = "cellId"
    
    private var Info: [String] = ["앱 정보" ,
                                  "이용약관",
                                  "개인정보 보호정책",
                                  "Open Source License"]
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        let shadowSize = CGSize(width: view.frame.width, height: 1)
        navigationController?.navigationBar.addColorToShadow(color: #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1),
                                                             size: shadowSize)
        navigationItem.title = "서비스 정보"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ServiceInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return ServiceInfoViewController.numberOfRows
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let serviceInfoCell = tableView.dequeueReusableCell(withIdentifier: ServiceInfoViewController.cellId)
            as? ServiceInfoTableViewCell else { return UITableViewCell() }
        
        serviceInfoCell.selectionStyle = .none
        serviceInfoCell.cellInfo = Info[indexPath.row]
        
        return serviceInfoCell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        guard let notiCase = NotificationInfo(rawValue: indexPath.row) else {return}
        
        let storyboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        switch notiCase {
        case .notification:
            guard let appInfoVC
                = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.appInfoViewController)
                    as? AppInfoViewController else {
                        return
            }
            
            navigationController?.pushViewController(appInfoVC,
                                                     animated: true)
        
        // FIXME: - privateProtect와 termnsOfService의 이름이 바뀌었습니다.
        case .privateProtect:
            guard let termsOfServiceViewController
                = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.termsOfServiceViewController)
                    as? TermsOfServiceViewController else {
                        return
            }
            
            navigationController?.pushViewController(termsOfServiceViewController,
                                                     animated: true)
        case .termsOfService:
            guard let privateProtectViewController
                = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.privateProtectViewController)
                    as? PrivateProtectViewController else {
                        return
            }
            
            navigationController?.pushViewController(privateProtectViewController,
                                                     animated: true)
        case .openSourceLicense:
            guard let OSLViewController
                = storyboard.instantiateViewController(withIdentifier: "OSLVC")
                    as? OSLViewController else {
                        return
            }
            
            navigationController?.pushViewController(OSLViewController,
                                                     animated: true)
        }
    }
    
}

enum NotificationInfo: Int {
    case notification = 0
    case termsOfService = 1
    case privateProtect = 2
    case openSourceLicense = 3
}
