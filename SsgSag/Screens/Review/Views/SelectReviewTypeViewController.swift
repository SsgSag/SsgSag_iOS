//
//  SelectReviewTypeViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/03/24.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SelectReviewTypeViewController: UIViewController {
    typealias TabModel = ReviewTabCellModel
    @IBOutlet weak var adCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adCollectionView.dataSource = self
        adCollectionView.delegate = self
    }

    @IBAction func clubReviewClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewMainVC") as? ReviewMainViewController else {
            return
        }
        nextVC.mainType = .club
        nextVC.tabTitle = [
            TabModel(title: "교내 동아리", onFocus: true),
            TabModel(title: "연합 동아리", onFocus: false)
        ]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func activityReviewClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewMainVC") as? ReviewMainViewController else {
            return
        }
        nextVC.mainType = .activity
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func internReviewClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewMainVC") as? ReviewMainViewController else {
            return
        }
        nextVC.mainType = .intern
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension SelectReviewTypeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementCell", for: indexPath) as? AdvertisementCollectionViewCell else {
            return UICollectionViewCell()
        }
        let testURL = "http://blogfiles.naver.net/MjAxOTEwMzFfMjQ2/MDAxNTcyNTI1NzE3NzM4.-rJYjo_lGMAw_RJibjHpfNjdnxn6JSFyTgWCQSiBpG8g.cXoAAvaSmPLO7UdgNKSRKMqs3MUT8rWZGFnI5VGX_NUg.JPEG.microibm/%B4%EB%B1%B8%B0%A1%C0%BB%BF%A9%C7%E0%B4%DC%C7%B3%C7%B3%B0%E6%BB%E7%C1%F86_3496.JPG"
        cell.imgString = testURL
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 188)
    }
}
