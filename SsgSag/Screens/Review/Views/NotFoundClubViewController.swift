//
//  NotFoundClubViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/05.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategorySelectModel {
    var title = ""
    var onClick: Bool = false
    
    init(title: String) {
        self.title = title
    }
}

class NotFoundClubViewController: UIViewController {

    var clubactInfo: ClubActInfoModel!
    let categoryTitleSet = ["스터디/학회", "어학", "봉사", "여행", "스포츠", "문화생활", "음악/에술", "IT/SW", "창업", "친목", "기타"]
    let cellModel: BehaviorRelay<[CategorySelectModel]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    var selectCount = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clubNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubNameTextField.text = clubactInfo.clubName
        let nib = UINib(nibName: "InputCategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "InputCategoryCell")
        collectionView.delegate = self
        setupCategoryCollectionView(titleSet: categoryTitleSet)
        bind()
       
    }
    
    func setupCategoryCollectionView(titleSet: [String]) {
        var dataSet: [CategorySelectModel] = []
        titleSet.forEach { dataSet.append(CategorySelectModel(title: $0)) }
        cellModel.accept(dataSet)
    }
    
    func bind() {
        cellModel.bind(to: collectionView.rx.items(cellIdentifier: "InputCategoryCell")) { [weak self] (indexPath, cellViewModel, cell) in
            
            guard let cell = cell as? InputCategoryCollectionViewCell else {return}
            guard let cellModel = self?.cellModel else {return}
            cell.bind(model: cellModel.value, item: indexPath)
        
        }.disposed(by: disposeBag)
        
        collectionView
            .rx
            .itemSelected
            .do(onNext: { [weak self] index in
                guard let selectCount = self?.selectCount else {return}
               
                if self?.cellModel.value[index.item].onClick == true {
                    self?.cellModel.value[index.item].onClick = false
                    self?.selectCount -= 1
                } else if selectCount < 3 {
                    self?.cellModel.value[index.item].onClick = true
                    self?.selectCount += 1
                }
                guard let cellModelList = self?.cellModel.value else {return}
                self?.cellModel.accept(cellModelList)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        cellModel.subscribe(onNext: { [weak self]items in
            let selectItems = items
                .filter{$0.onClick == true}
                .map{$0.title}
            
            self?.clubactInfo.categoryList = selectItems
        })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "StarRatingVC") as? StarRatingViewController else {return}
        nextVC.clubactInfo = clubactInfo
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension NotFoundClubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = cellModel.value[indexPath.item].title.estimatedFrame(font: .systemFont(ofSize: 15)).size.width
        
        return CGSize(width: width + 20, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
