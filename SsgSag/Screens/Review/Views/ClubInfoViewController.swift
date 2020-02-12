//
//  ClubInfoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ClubInfoViewController: UIViewController {

    @IBOutlet weak var emptyClubInfoView: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var webSiteLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var meetingLabel: UILabel!
    @IBOutlet weak var activeNumLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var imgSet: [String] = []
    var tabViewModel: ClubDetailViewModel!
    var disposeBag: DisposeBag!
    let indicator = UIActivityIndicatorView()
    let showPhotoMaximum = 6
    var clubIdx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        labelGestureAdd()
        disposeBag = DisposeBag()
        setIndicatorView()
        bind()
        
    }
    
    func bind() {
        self.tabViewModel.clubInfoData
            .compactMap{ $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
            
                guard !(data.activeNum == "") else {
                    self?.emptyClubInfoView.isHidden = false
                    self?.indicator.stopAnimating()
                    return
                }
                self?.clubIdx = data.clubIdx
                self?.activeNumLabel.text = data.activeNum
                self?.meetingLabel.text = data.meetingTime
                self?.feeLabel.text = data.clubFee
                self?.webSiteLabel.text = data.clubWebsite
                self?.introduceLabel.text = data.introduce
                
                self?.imgSet = data.clubPhotoUrlList.removeComma()
                self?.photoCollectionView.reloadData()
                self?.view.layoutIfNeeded()
                
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
        guard let url = URL(string: urlString) else {
            self.simplerAlert(title: "잘못된 주소입니다.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func registerClubInfo(_ sender: Any) {
        performSegue(withIdentifier: "SelectClubManagerSegue", sender: self)
    }
    
    deinit {
        print("memory - info 종료")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else {return}
        guard let nextVC = navigationVC.topViewController as? SelectClubManagerViewController else {return}
        nextVC.isReviewExist = true
        nextVC.clubIdx = clubIdx
    }
}
