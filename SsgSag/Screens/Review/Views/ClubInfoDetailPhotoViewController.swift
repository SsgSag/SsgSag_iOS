//
//  ClubInfoDetailPhotoViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/18.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ClubInfoDetailPhotoViewController: UIViewController {

    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoURLSet = BehaviorRelay<[String]>(value: [])
    var photoCurIndex = BehaviorRelay<Int>(value: -1)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        collectionViewSet()
        let indexPath = IndexPath(item: photoCurIndex.value, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }
    
    func collectionViewSet() {
        let nib = UINib(nibName: "ClubInfoDetailPhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ClubInfoDetailPhotoCell")
        
        photoURLSet
            .bind(to: collectionView.rx.items(cellIdentifier: "ClubInfoDetailPhotoCell")) { [weak self] (indexPath, cellViewModel, cell)  in
                guard let cell = cell as? ClubInfoDetailPhotoCollectionViewCell else {return}
                guard let photoURLSet = self?.photoURLSet.value else {return}
                cell.bind(photoURLString: photoURLSet[indexPath])
        }
        .disposed(by: disposeBag)
        
        collectionView
            .rx
            .didEndDecelerating
            .subscribe(onNext: { [weak self] ha in
                guard let pageWidth = self?.collectionView.frame.width else {return}
                guard let contentXPos = self?.collectionView.contentOffset.x else {return}
                let page = Int(contentXPos / pageWidth)
                self?.photoCurIndex.accept(page)
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {
        photoCurIndex
            .distinctUntilChanged()
            .filter{ $0 >= 0 }
            .subscribe(onNext: { [weak self] page in
                guard let photoCount = self?.photoURLSet.value.count else {return}
                self?.photoCountLabel.text = "\(page+1)/\(photoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
