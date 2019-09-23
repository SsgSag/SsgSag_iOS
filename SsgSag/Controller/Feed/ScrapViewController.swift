//
//  ScrapViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 23/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ScrapViewController: UIViewController {

    private lazy var scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width,
                                 height: 220)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_backFeed"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "북마크"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = backButton
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(scrapCollectionView)
        
        scrapCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrapCollectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrapCollectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrapCollectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        scrapCollectionView.register(NewsCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "scrapCell")
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

}

extension ScrapViewController: UICollectionViewDelegate {
    
}

extension ScrapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrapCell",
                                                            for: indexPath)
            as? NewsCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        return cell
    }
}
