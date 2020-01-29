//
//  ClubInfoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ClubInfoViewController: UIViewController {

    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var webSiteLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var meetingLabel: UILabel!
    @IBOutlet weak var activeNumLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var infoPhotoURLSet: [String] = []
    let tabViewModel = ClubDetailViewModel.shared
    var disposeBag: DisposeBag!
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        labelGestureAdd()
        disposeBag = DisposeBag()
        bind()
        setIndicatorView()
    }
    
    func bind() {
        self.tabViewModel.clubInfoData
        .filter { $0 != nil }
        .map { $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            guard data != nil else { return }
            self?.activeNumLabel.text = data!.activeNum
            self?.meetingLabel.text = data!.meetingTime
            self?.feeLabel.text = data!.clubFee
            self?.webSiteLabel.text = data!.clubWebsite
            self?.introduceLabel.text = data!.introduce
            self?.infoPhotoURLSet = data!.clubPhotoUrlList.removeComma()
            
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadData()
                self?.view.layoutIfNeeded()
            }
            self?.indicator.stopAnimating()
        })
        .disposed(by: disposeBag)
    }
    
    func setIndicatorView() {
        indicator.style = .whiteLarge
        indicator.color = .gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func labelGestureAdd() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openURL))
        self.homePageLabel.addGestureRecognizer(tap)
    }

    @objc func openURL() {
        guard let urlString = self.homePageLabel.text else { return }
        let url = URL(string: urlString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    deinit {
        print("memory - info 종료")
    }
}
