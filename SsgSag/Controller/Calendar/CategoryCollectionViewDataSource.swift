//
//  CategoryCollectionViewDataSource.swift
//  SsgSag
//
//  Created by 이혜주 on 23/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CategoryCollectionViewDataSourece: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryHeaderCell",
                                                     for: indexPath)
                    as? CategoryHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setLabelWith("전체")
            
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                collectionView.selectItem(at: indexPath,
                                          animated: false,
                                          scrollPosition: .left)
                cell.didSelectedCell()
            }
            
            return cell
        case 1:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryHeaderCell",
                                                     for: indexPath)
                    as? CategoryHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setLabelWith("즐겨찾기")
            
            return cell
        default:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                     for: indexPath)
                    as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setCategoryButtonWith(index: indexPath.item)
            
            return cell
        }
    }
}

class CategoryHeaderCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15,
                                 weight: .medium)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
    }
    
    func setLabelWith(_ text: String) {
        titleLabel.text = text
    }
    
    func didSelectedCell() {
        titleLabel.textColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 15,
                                      weight: .semibold)
    }
    
    func didDeselectedCell() {
        titleLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 15,
                                      weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CategoryCollectionViewCell: UICollectionViewCell {
    let categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.lightGray,
                             for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3)
        button.layer.cornerRadius = 6
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(categoryButton)
        
        categoryButton.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        categoryButton.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
        categoryButton.widthAnchor.constraint(
            equalTo: widthAnchor).isActive = true
    }
    
    private func getCategoryIndex(_ index: Int) -> Int {
        switch index {
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 4
        case 5:
            return 7
        default:
            return 5
        }
    }
    
    func setCategoryButtonWith(index: Int) {
        if let category = PosterCategory(rawValue: getCategoryIndex(index)) {
            categoryButton.setTitle(category.categoryString(),
                                    for: .normal)
        }
    }
    
    func didSelectedCell(index: Int) -> [Int] {
        let categoryIndex = getCategoryIndex(index)
        
        if let category = PosterCategory(rawValue: categoryIndex) {
            categoryButton.setTitleColor(category.categoryColors(),
                                         for: .normal)
            categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
        }
        
        return [categoryIndex]
    }
    
    func didDeselectedCell() {
        categoryButton.setTitleColor(.lightGray,
                                     for: .normal)
        categoryButton.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
