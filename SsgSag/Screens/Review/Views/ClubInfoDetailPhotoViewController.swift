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

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let photoURLSet = BehaviorRelay<[String]>(value: [])
    let photoCurIndex = BehaviorRelay<Int>(value: -1)
    let isHiddenTopUIObservable = BehaviorRelay(value: true)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        collectionViewSet()
        
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(isHiddenUI))
        collectionView.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHiddenUI()
    }
    
    @objc func isHiddenUI() {
        let isHidden = isHiddenTopUIObservable.value
        isHiddenTopUIObservable.accept(!isHidden)
    }

    func collectionViewSet() {
        let nib = UINib(nibName: "ClubInfoDetailPhotoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ClubInfoDetailPhotoCell")
        
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        
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
        
        self.view.layoutIfNeeded()
        let indexPath = IndexPath(item: photoCurIndex.value, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        
    }
    
    func bind() {
        photoCurIndex
            .asDriver()
            .distinctUntilChanged()
            .filter{ $0 >= 0 }
            .drive(onNext: { [weak self] page in
                guard let photoCount = self?.photoURLSet.value.count else {return}
                self?.photoCountLabel.text = "\(page+1)/\(photoCount)"
            })
            .disposed(by: disposeBag)
        
        isHiddenTopUIObservable
            .asDriver()
            .drive(onNext: { [weak self] isHidden in
                self?.photoCountLabel.isHidden = isHidden
                self?.cancelButton.isHidden = isHidden
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ClubInfoDetailPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}

extension ClubInfoDetailPhotoViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
        let offset = targetContentOffset.pointee
        let cellWidthIncludingSpacing = self.collectionView.frame.width
        let index = Int(offset.x / cellWidthIncludingSpacing)
        
        photoCurIndex.accept(index)
    }
}
