//
//  SelectedTodoViewController.swift
//  SsgSag
//
//  Created by admin on 14/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SelectedTodoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let testNUmber = ["1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    
    let testVIew: UITableView = {
        let label = UITableView()
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let testVIew2: UITableView = {
        let label = UITableView()
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let testVIew3: UITableView = {
        let label = UITableView()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGesture()
        
        testVIew.delegate = self
        testVIew2.delegate = self
        testVIew3.delegate = self
        
        testVIew.dataSource = self
        testVIew2.dataSource = self
        testVIew3.dataSource = self
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        
        scrollView.addSubview(testVIew)
        scrollView.addSubview(testVIew2)
        scrollView.addSubview(testVIew3)
        
        testVIew.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        testVIew.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        testVIew.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.8).isActive = true
        testVIew.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        testVIew2.centerXAnchor.constraint(equalTo: testVIew.centerXAnchor, constant: self.view.frame.width).isActive = true
        testVIew2.topAnchor.constraint(equalTo: testVIew.topAnchor).isActive = true
        testVIew2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        testVIew2.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        testVIew3.centerXAnchor.constraint(equalTo: testVIew2.centerXAnchor, constant: self.view.frame.width).isActive = true
        testVIew3.topAnchor.constraint(equalTo: testVIew.topAnchor).isActive = true
        testVIew3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        testVIew3.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y != 0 {
                print("scrollView is scrolled")
                scrollView.contentOffset.y = 0
            }
        } else if scrollView == self.testVIew {
            print("testView is scrolled")
        } else if scrollView == self.testVIew2 {
            print("testView is scrolled")
        } else if scrollView == self.testVIew3 {
            print("testView is scrolled")
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDisView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissDisView() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("SelectedTodoViewController is deleted")
    }
    
}

extension SelectedTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testNUmber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.backgroundColor = .red
        return tableViewCell
    }
    
}
