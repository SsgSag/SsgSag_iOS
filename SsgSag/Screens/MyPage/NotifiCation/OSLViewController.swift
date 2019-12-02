//
//  OSLViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 25/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Lottie

class OSLViewController: UIViewController {

    private let OSLList: [OSL] = [OSL(name: "Lottie-iOS",
                                      url: "https://github.com/airbnb/lottie-ios",
                                      copyRight: "Copyright 2018 Airbnb, Inc.",
                                      license: "Apache License 2.0"),
                                  OSL(name: "SearchTextField",
                                      url: "https://github.com/apasccon/SearchTextField",
                                      copyRight: "Copyright (c) 2016 Alejandro Pasccon <apasccon@gmail.com>",
                                      license: "MIT License"),
                                  OSL(name: "SwiftKeychainWrapper",
                                      url: "https://github.com/jrendel/SwiftKeychainWrapper",
                                      copyRight: "Copyright (c) 2014 Jason Rendel",
                                      license: "MIT License")]
    
    @IBOutlet weak var headerTextView: UITextView!
    
    @IBOutlet weak var OSLTableView: UITableView!
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "OSL"
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupTableView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
//        let attributedString = NSMutableAttributedString(string: text)
        let emailStirng = "opensource@ssgsag.com"
//        let url = URL(string: urlStirng)!
//
//        attributedString.setAttributes([.link: url], range: NSMakeRange(70, 73))
//
//        self.headerTextView.attributedText = attributedString
//        self.headerTextView.isUserInteractionEnabled = true
//        self.headerTextView.isEditable = false
//
//        self.headerTextView.linkTextAttributes = [
//            .foregroundColor: UIColor.blue,
//            .underlineStyle: NSUnderlineStyle.single.rawValue
//        ]
        
        let attributedString = NSMutableAttributedString(string: """
            This application is Copyright - Ssgsag Corp. All rights reserved.
            
            The following sets forth attribution notices for third party
            software that may be contained in this application.
            
            If you have any questions or concerns, please contact us at \(emailStirng)
            """)
        
        self.headerTextView.attributedText = attributedString
        self.headerTextView.linkTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.blue,
               NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        self.headerTextView.dataDetectorTypes = UIDataDetectorTypes.all
    }
    
    private func setupTableView() {
        let OSLNib = UINib(nibName: "OSLTableViewCell",
                           bundle: nil)
        OSLTableView.register(OSLNib,
                              forCellReuseIdentifier: "OSLCell")
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension OSLViewController: UITableViewDelegate {
    
}

extension OSLViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell
            = tableView.dequeueReusableCell(withIdentifier: "OSLCell",
                                            for: indexPath) as? OSLTableViewCell else {
            return .init()
        }
        
        cell.OSLData = OSLList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

struct OSL {
    let name: String
    let url: String
    let copyRight: String
    let license: String
}
