//
//  NotificationInfoTableViewController.swift
//  SsgSag
//
//  Created by admin on 21/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NotificationInfoTableViewController: UITableViewController {

    private let noticeServiceImp: NoticeService
        = DependencyContainer.shared.getDependency(key: .noticeService)
    
    private var noticeList: [NoticeData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNoticeData()
        setupTableView()
    }
    
    private func requestNoticeData() {
        
        noticeServiceImp.requestNotice { [weak self] response in
            switch response {
            case .success(let noticeList):
                self?.noticeList = noticeList
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failed(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(ServiceInfoTableViewCell.self, forCellReuseIdentifier: "noticeCell")
    }
    
    @IBAction func dissmissNotification(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension NotificationInfoTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell",
                                                       for: indexPath) as? ServiceInfoTableViewCell else {
            return .init()
        }
        
        if indexPath.row == 0 {
            cell.showNewPostImage()
        }
        
        cell.cellInfo = noticeList[indexPath.row].noticeName
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postViewController = PostViewController()
        postViewController.noticeData = noticeList[indexPath.row]
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

extension NotificationInfoTableViewController: UIGestureRecognizerDelegate {
}
