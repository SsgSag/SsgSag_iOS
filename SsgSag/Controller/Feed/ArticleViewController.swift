//
//  ArticleViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 07/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {

    var articleTitle: String?
    var articleUrlString: String?
    
    private var indicator = UIActivityIndicatorView()
    
    private lazy var articleWebView: WKWebView = {
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
        
        
        setNavigationBar(color: .white)
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)]
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backbutton
        navigationController?.hidesBarsOnSwipe = true
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        titleLabel.text = articleTitle ?? ""
        titleLabel.textColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.clipsToBounds = false
        self.navigationItem.titleView = titleLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let articleUrl = URL(string: articleUrlString ?? "") else {
            return
        }
        
        let request = URLRequest(url: articleUrl)
        articleWebView.load(request)
    }
    
    override func loadView() {
        super.loadView()
        
        view = articleWebView
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ArticleViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator = UIActivityIndicatorView(style: .gray)
        indicator.frame = CGRect(x: view.frame.midX - 50,
                                 y: view.frame.midY,
                                 width: 100,
                                 height: 100)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.removeFromSuperview()
    }
}