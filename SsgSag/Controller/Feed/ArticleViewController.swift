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

    var callback: (()->())?
    var feedIdx: Int?
    var articleTitle: String?
    var articleUrlString: String?
    var isSave: Int? {
        didSet {
            guard let isSave = isSave else {
                return
            }
            
            if isSave == 1 {
                scrapButton.setImage(UIImage(named: "ic_bookmark"), for: .normal)
            } else {
                scrapButton.setImage(UIImage(named: "ic_bookmarkPassive"), for: .normal)
            }
        }
    }
    
    private var indicator = UIActivityIndicatorView()
    private var feedService: FeedService
        = DependencyContainer.shared.getDependency(key: .feedService)
    
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
    
    private lazy var scrapButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(touchUpScrapButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var rightBarButton = UIBarButtonItem(customView: self.scrapButton)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)]
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backbutton
        navigationController?.hidesBarsOnSwipe = true
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let titleLabel = UILabel()
        titleLabel.text = articleTitle ?? ""
        titleLabel.textColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 1
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
    
    private func requestScrap() {
        guard let feedIdx = feedIdx else {
            return
        }
        
        feedService.requestScrapStore(feedIndex: feedIdx) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    DispatchQueue.main.async {
                        self?.scrapButton.setImage(UIImage(named: "ic_bookmark"),
                                                   for: .normal)
                    }
                    print("스크랩 완료")
                    return
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("서버 에러")
                    return
                default:
                    print("저장 실패")
                    return
                }
            case .failed:
                assertionFailure()
                return
            }
        }
    }
    
    private func requestScrapDelete() {
        guard let feedIdx = feedIdx else {
            return
        }
        
        feedService.requestScrapDelete(feedIndex: feedIdx) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    DispatchQueue.main.async {
                        self?.scrapButton.setImage(UIImage(named: "ic_bookmarkPassive"),
                                                   for: .normal)
                    }
                    print("스크랩 취소 완료")
                    return
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("서버 에러")
                    return
                default:
                    print("저장 실패")
                    return
                }
            case .failed:
                assertionFailure()
                return
            }
        }
    }
    
    @objc private func touchUpBackButton() {
        callback?()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpScrapButton() {
        if scrapButton.imageView?.image == UIImage(named: "ic_bookmarkPassive") {
            requestScrap()
        } else {
            requestScrapDelete()
        }
    }
    
}

extension ArticleViewController: UIGestureRecognizerDelegate {
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
