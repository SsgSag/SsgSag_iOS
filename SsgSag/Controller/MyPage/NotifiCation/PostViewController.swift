//
//  PostViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var noticeData: NoticeData?
    
//    private let contentsTextView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.font = UIFont.systemFont(ofSize: 14)
//        textView.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
//        return textView
//    }()
//
    private lazy var postTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var backbutton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = backbutton
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = noticeData?.noticeName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupTableView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(postTableView)
        
        postTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        postTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        postTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCellID")
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

}

extension PostViewController: UITableViewDelegate {
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCellID",
                                                       for: indexPath) as? PostTableViewCell else {
            return .init()
        }
        
        if indexPath.row == 0 {
            cell.setContentsLabel(color: #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1), size: 14, text: "asdf")
        } else {
            cell.setContentsLabel(color: #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), size: 13, text: "asdf")
        }
        return cell
    }
}
