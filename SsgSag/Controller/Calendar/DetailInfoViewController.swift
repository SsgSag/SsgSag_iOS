//
//  DetailInfoViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DetailInfoViewController: UIViewController {

    private var posterServiceImp: PosterService?
    var posterIdx: Int?
    var posterDetailData: DataClass?
    var isFolding: Bool = false
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.sectionFootersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let safeAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        return view
    }()
    
    let buttonsView = DetailInfoButtonsView()
    
    private lazy var shareBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "공유",
                                        style: .plain,
                                        target: self,
                                        action: nil)
        
        barButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        return barButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestDatas()
        setupLayout()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        infoCollectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: self.safeAreaView.frame.height + self.buttonsView.frame.height,
                                                       right: 0)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "상세정보"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(touchUpBackButton))
        
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    private func requestDatas(_ posterService: PosterService = PosterServiceImp()) {
        posterServiceImp = posterService
        
        guard let posterIdx = posterIdx else { return }
        
        posterServiceImp?.requestPosterDetail(posterIdx: posterIdx) { [weak self] response in
            switch response {
            case .success(let detailData):
                self?.posterDetailData = detailData
                
                DispatchQueue.main.async {
                    self?.infoCollectionView.reloadData()
                }
            case .failed(let error):
                assertionFailure(error.localizedDescription)
                return
            }
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(infoCollectionView)
        infoCollectionView.addSubview(buttonsView)
        infoCollectionView.addSubview(safeAreaView)
        
        infoCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoCollectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        infoCollectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        infoCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        buttonsView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonsView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonsView.heightAnchor.constraint(
            equalToConstant: 46).isActive = true
        buttonsView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        safeAreaView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        safeAreaView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(
            equalTo:view.bottomAnchor).isActive = true
    }

    private func setupCollectionView() {
        // header
        let posterHeaderNib = UINib(nibName: "PosterHeaderCollectionReusableView", bundle: nil)
        
        infoCollectionView.register(posterHeaderNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "posterHeaderID")
        
        infoCollectionView.register(TempCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "tempHeader")
        
        // footer
        let posterFooterNib = UINib(nibName: "PosterFooterCollectionReusableView", bundle: nil)
        
        infoCollectionView.register(posterFooterNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: "posterFooterID")
        
        infoCollectionView.register(TempCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: "tempFooter")
        
        // cell
        let detailImgNib = UINib(nibName: "DetailImageCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(detailImgNib, forCellWithReuseIdentifier: "detailImgCellID")
        
        let detailInfoNib = UINib(nibName: "DetailInfoCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(detailInfoNib, forCellWithReuseIdentifier: "detailInfoCellID")
        
        let contactInfoNib = UINib(nibName: "ContactInfoCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(contactInfoNib, forCellWithReuseIdentifier: "contactInfoCellID")
        
        let seeMoreNib = UINib(nibName: "SeeMoreCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(seeMoreNib, forCellWithReuseIdentifier: "seeMoreCellID")
        
        let analyticsNib = UINib(nibName: "AnalysticsCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(analyticsNib, forCellWithReuseIdentifier: "analyticsCellID")
        
        let commentNib = UINib(nibName: "CommentCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(commentNib, forCellWithReuseIdentifier: "commentCellID")
        
        let commentWriteNib = UINib(nibName: "CommentWriteCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(commentWriteNib, forCellWithReuseIdentifier: "commentWriteCellID")
        
    }

    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: view.frame.width - 75, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailInfoViewController: UICollectionViewDelegate {
    
}

extension DetailInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 8 + (posterDetailData?.commentList?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailImgCellID",
                                                     for: indexPath) as? DetailImageCollectionViewCell else {
                                                        return .init()
            }
            
            return cell
        case 1:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                     for: indexPath) as? DetailInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(titleString: "항목",
                           detailString: posterDetailData?.outline ?? "")
            
            return cell
        case 2:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                     for: indexPath) as? DetailInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(titleString: "항목",
                           detailString: posterDetailData?.target ?? "")
            
            return cell
        case 3:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                     for: indexPath) as? DetailInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(titleString: "항목",
                           detailString: posterDetailData?.benefit ?? "")
            
            return cell
        case 4:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "contactInfoCellID",
                                                     for: indexPath) as? ContactInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(phoneNumber: posterDetailData?.partnerPhone ?? "", email: posterDetailData?.partnerEmail ?? "")
            
            return cell
        case 5:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "seeMoreCellID",
                                                     for: indexPath) as? SeeMoreCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(contents: posterDetailData?.posterDetail ?? "")
            
            return cell
        case 6:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "analyticsCellID",
                                                     for: indexPath) as? AnalysticsCollectionViewCell else {
                                                        return .init()
            }
            
            return cell
        case 8 + (posterDetailData?.commentList?.count ?? 0) - 1:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "commentWriteCellID",
                                                     for: indexPath) as? CommentWriteCollectionViewCell else {
                                                        return .init()
            }
            
            return cell
        default:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCellID",
                                                     for: indexPath) as? CommentCollectionViewCell else {
                                                        return .init()
            }
            
            guard let comment = posterDetailData?.commentList?[indexPath.item - 7] else {
                return cell
            }
            
            cell.configure(comment: comment)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "posterHeaderID", for: indexPath) as? PosterHeaderCollectionReusableView else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            header.configure(data: posterDetailData)
            
            if let photoURL = posterDetailData?.photoUrl {
                if let url = URL(string: photoURL){
                    ImageNetworkManager.shared.getImageByCache(imageURL: url) { image, error in
                        DispatchQueue.main.async { 
                            header.posterImageView.image = image
                        }
                    }
                }
            }
            
            return header
        } else {
//            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                               withReuseIdentifier: "posterFooterID",
//                                                                               for: indexPath) as? PosterFooterCollectionReusableView else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempFooter",
                                                                       for: indexPath)
//            }
//
//            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 자세히 보기를 눌렀을 때
        if indexPath.item == 5 {
            let indexPaths = [indexPath]
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

extension DetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 243)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 80)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: view.frame.width, height: 41)
        case 1:
            let collectionViewCellHeight = estimatedFrame(text: posterDetailData?.outline ?? "",
                                                          font: UIFont.systemFont(ofSize: 14)).height
            
            return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
        case 2:
            let collectionViewCellHeight = estimatedFrame(text: posterDetailData?.target ?? "",
                                                          font: UIFont.systemFont(ofSize: 14)).height
            
            return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
        case 3:
            let collectionViewCellHeight = estimatedFrame(text: posterDetailData?.benefit ?? "",
                                                          font: UIFont.systemFont(ofSize: 14)).height
            
            return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
        case 4:
            guard let _ = posterDetailData?.partnerPhone,
                let _ = posterDetailData?.partnerEmail else {
                return CGSize(width: 0, height: 0)
            }
            
            return CGSize(width: view.frame.width, height: 106)
        case 5:
            if isFolding {
                isFolding = !isFolding
                return CGSize(width: view.frame.width, height: 46)
            } else {
                isFolding = !isFolding
                
                let collectionViewCellHeight = estimatedFrame(text: posterDetailData?.posterDetail ?? "",
                                                              font: UIFont.systemFont(ofSize: 12)).height
                
                return CGSize(width: view.frame.width, height: collectionViewCellHeight + 50 + 46)
            }
        case 6:
            return CGSize(width: view.frame.width, height: 198)
        case 8 + (posterDetailData?.commentList?.count ?? 0) - 1:
            return CGSize(width: view.frame.width, height: 46)
        default:
            return CGSize(width: view.frame.width, height: 200)
        }

    }
}
