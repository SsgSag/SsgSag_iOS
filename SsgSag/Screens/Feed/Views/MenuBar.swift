//
//  MenuBar.swift
//  SsgSag
//
//  Created by 이혜주 on 11/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol MenuBarDelegate: class {
    func getSelectedMenu(index: Int)
}

class MenuBar: UIView {
    
    let menuTitle: [String] = ["슥삭 추천뉴스", "대학교 게시판"]
    var horizontalBarViewLeadingConstraint: NSLayoutConstraint?
    var feedVC: FeedVC?
    var delegate: MenuBarDelegate?
    
    lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.contentInset = UIEdgeInsets(top: 0,
//                                                   left: frame.width / 2,
//                                                   bottom: 0,
//                                                   right: frame.width / 2)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupLayout()
        setupHorizontalBar()
    }
    
    private func setupLayout() {
        addSubview(menuCollectionView)
        
        menuCollectionView.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        menuCollectionView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        menuCollectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor).isActive = true
        menuCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor).isActive = true
    }
    
    private func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        addSubview(horizontalBarView)
        
        horizontalBarViewLeadingConstraint = horizontalBarView.leadingAnchor.constraint(
            equalTo: leadingAnchor)
        
        horizontalBarViewLeadingConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(
            equalToConstant: 3).isActive = true
//        horizontalBarView.widthAnchor.constraint(equalToConstant: frame.width / 2)
        horizontalBarView.widthAnchor.constraint(
            equalTo: widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupCollectionView() {
        
        menuCollectionView.register(MenuCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "menuCell")
        
//        menuCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
//                                        at: .left,
//                                        animated: false)
    }
}

extension MenuBar: UICollectionViewDelegate {
    
}

extension MenuBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell",
                                                 for: indexPath)
                as? MenuCollectionViewCell else {
                    return .init()
        }
        
        cell.titleLabel.text = menuTitle[indexPath.item]
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath,
                                  animated: false,
                                  scrollPosition: .centeredHorizontally)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
       // let cell = collectionView.cellForItem(at: indexPath)
//        collectionView.scrollsToTop
        
        let x = CGFloat(indexPath.item) * frame.width / 2
        horizontalBarViewLeadingConstraint?.constant = x
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.layoutIfNeeded()
                        },
                       completion: nil)

        feedVC?.scrollToMenuIndex(indexPath.item)
    }

}

extension MenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuCollectionView.frame.width / 2, height: frame.height)
    }
}

extension MenuBar {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let selectedIndex
            = menuCollectionView.indexPathsForSelectedItems?.first?.item else {
                return
        }
        
        delegate?.getSelectedMenu(index: selectedIndex)
    }
}
