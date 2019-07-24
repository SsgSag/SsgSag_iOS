//
//  PostViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import WebKit

class PostViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var noticeData: NoticeData?
    
    private lazy var noticeWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
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
    
    override func loadView() {
        super.loadView()
        
        self.view = self.noticeWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeWebView.loadHTMLString(noticeData?.noticeContent ?? "", baseURL: nil)
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

}
