//
//  InterestBoardViewController.swift
//  SsgSag
//
//  Created by admin on 13/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class InterestBoardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    typealias info = (String, String, Follow)
    
    private var interestInfo: [SubscribeInterests] = []
    
    private let interestService: InterestService
        = DependencyContainer.shared.getDependency(key: .interestService)
    
    static private let numberOfRows = 3
    
    static private let cellId = "interestBoardcellId"
    
    static private let rowHeight: CGFloat = 74
    
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(touchUpBackButton))
    
    lazy var doneButton = UIBarButtonItem(title: "완료",
                                          style: .plain,
                                          target: self,
                                          action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        doneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib.InterestBoardNIB, forCellReuseIdentifier: InterestBoardViewController.cellId)
        
        requestSubscribeStatus()
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func requestSubscribeStatus() {
        interestService.requestInterestSubscribe{ (dataResponse) in
            guard let data = dataResponse.value else {return}
        
            guard let interests = data.data else {return}
            
            DispatchQueue.main.async {
                self.interestInfo = interests
                
                self.tableView.reloadData()
            }
        }
    }

}

extension InterestBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let interestBoardCell = tableView.dequeueReusableCell(withIdentifier: InterestBoardViewController.cellId) as? InterestBoardTableViewCell else { return .init() }
        
        interestBoardCell.selectionStyle = .none
        
        interestBoardCell.interestFollowDelegate = self
        
        interestBoardCell.interestInfo = self.interestInfo[indexPath.row]
        
        interestBoardCell.indexPath = indexPath
        
        return interestBoardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InterestBoardViewController.rowHeight
    }

}

extension InterestBoardViewController: InterestFollowDelegate {
    
    func interestFollowButton(using interest: SubscribeInterests, indexPath: IndexPath) {
        
        guard let userIdx = interest.userIdx else {return}
        
        guard let interestIdx = interest.interestIdx else {return}
        
        //구독 안된 상태
        if userIdx == 0 {
            interestService.requestInterestSubscribeAdd(interestIdx) { dataResponse in
                guard let data = dataResponse.value else {return}
                
                guard let status = data.status else {return}
                
                guard let statusCode = HttpStatusCode(rawValue: status) else {return}
                
                DispatchQueue.main.async {
                    switch statusCode {
                    case .sucess:
                        self.simplerAlert(title: "구독 등록을 성공 하였습니다.")
                        self.requestSubscribeStatus()
                    default:
                        self.simplerAlert(title: "구독 등록을 실패 하였습니다.")
                    }
                }
            }
        } else {
            interestService.requestInterestSubscribeDelete(interestIdx) { dataResponse in
                
                guard let data = dataResponse.value else {return}
                
                guard let status = data.status else {return}
                
                guard let statusCode = HttpStatusCode(rawValue: status) else {return}
                
                DispatchQueue.main.async {
                    switch statusCode {
                    case .sucess:
                        self.simplerAlert(title: "구독 취소를 성공 하였습니다.")
                        self.requestSubscribeStatus()
                    default:
                        self.simplerAlert(title: "구독 등록을 실패 하였습니다.")
                    }
                }
            }
            
        }
    }
}

enum Follow {
    case follow
    case unFollow
}

extension UINib {
    static var InterestBoardNIB: UINib {
        return UINib(nibName: "InterestBoardTableViewCell", bundle: nil)
    }
}

enum InterestType: String {
    case competition = "공모전"
    case activities = "대외활동"
    case inter = "인턴"
    
    func hashTagString() -> String {
        switch self {
        case .competition:
            return "#공모전#경진대회#게시판"
        case .activities:
            return "#서포터즈#체험단"
        case .inter:
            return "#인턴#채용정보"
        }
    }
}

