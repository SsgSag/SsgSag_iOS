//
//  DetailInfoViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AdBrixRM

class DetailInfoViewController: UIViewController {
    var isCalendar: Bool = true
    var isSave: Int = 1
    
    private var safeAreaViewBottomConstraint = NSLayoutConstraint()
    private var posterServiceImp: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    private var commentServiceImp: CommentService
        = DependencyContainer.shared.getDependency(key: .commentService)
    private var calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    var currentTextField: UITextField?
    var callback: ((Int) -> ())?
    var posterIdx: Int?
    var posterDetailData: DataClass?
    private var isFolding: Bool = false
    private var columnData: [Column]?
    private var analyticsData: Analytics?
    
    let downloadLink = "https://ssgsag.page.link/install"
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
    
    lazy var buttonsView: DetailInfoButtonsView = {
        let view = DetailInfoButtonsView(isCalendar: self.isCalendar,
                                         isSave: self.isSave)
        view.delegate = self
        view.commentDelegate = self
        view.commentTextField.delegate = self
        view.saveAtCalendar = { [weak self] in
            self?.saveAtCalendar()
        }
        view.removeAtCalendar = { [weak self] in
            self?.removeAtCalendar()
        }
        view.callback = { [weak self] in
            self?.isFolding = true
            self?.requestDatas(section: 0)
        }
        return view
    }()
    
    private lazy var shareBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "공유",
                                        style: .plain,
                                        target: self,
                                        action: #selector(touchUpShareButton))
        barButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        return barButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleShowKeyboard),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleHideKeyboard),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
        
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
    
    private func requestDatas(section: Int? = nil) {
        guard let posterIdx = posterIdx else { return }
        
        posterServiceImp.requestPosterDetail(posterIdx: posterIdx) { [weak self] response in
            switch response {
            case .success(let detailData):
                self?.posterDetailData = detailData
                self?.buttonsView.posterIndex = posterIdx
                self?.buttonsView.isLike = detailData.isFavorite
                self?.buttonsView.isExistApplyURL = detailData.posterWebSite2 != nil ? true : false
                
                if detailData.categoryIdx == 3 || detailData.categoryIdx == 5 {
                    guard let columnJson = detailData.outline,
                        let data = columnJson.data(using: .utf8) else {
                            return
                    }
                    
                    do {
                        self?.columnData = try JSONDecoder().decode([Column].self,
                                                                    from: data)
                    } catch let error {
                        print(error)
                        return
                    }
                }
                
                guard let analyticsJson = detailData.analytics,
                    let data = analyticsJson.data(using: .utf8) else {
                    return
                }
                
                do {
                    self?.analyticsData = try JSONDecoder().decode(Analytics.self,
                                                                   from: data)
                } catch let error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    guard let section = section else {
                        self?.infoCollectionView.reloadData()
                        return
                    }
                    
                    self?.infoCollectionView.reloadSections(IndexSet(integer: section))
                }
            case .failed(let error):
                assertionFailure(error.localizedDescription)
                return
            }
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        buttonsView.delegate = self
        
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
            equalToConstant: 93).isActive = true
        buttonsView.bottomAnchor.constraint(
            equalTo: safeAreaView.topAnchor).isActive = true
        
        safeAreaViewBottomConstraint = safeAreaView.bottomAnchor.constraint(
            equalTo:view.bottomAnchor)
        
        safeAreaView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        safeAreaView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        safeAreaViewBottomConstraint.isActive = true
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
        infoCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "tempCell")
        
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
        
        let hideNib = UINib(nibName: "HideAnalyticsCommentsCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(hideNib, forCellWithReuseIdentifier: "hideAnalyticsCommentsCell")
        
        let noCommentNib = UINib(nibName: "NoCommentCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(noCommentNib, forCellWithReuseIdentifier: "noCommentCell")
        
    }
    
    func estimatedFrame(width: CGFloat, text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: width, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    private func saveAtCalendar() {
        guard let posterIdx = posterIdx else {
            assertionFailure()
            return
        }
        
        posterServiceImp.requestPosterStore(of: posterIdx,
                                            type: .liked) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    print("성공")
                case .dataBaseError:
                    self?.simplerAlert(title: "데이터베이스 에러")
                case .serverError:
                    self?.simplerAlert(title: "서버 에러")
                default:
                    print("슥/삭 실패")
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    private func removeAtCalendar() {
        guard let posterIdx = posterIdx else {
            assertionFailure()
            return
        }
        
        calendarService.requestTodoDelete(posterIdx) { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    switch status {
                    case .processingSuccess:
                        print("성공")
                    case .dataBaseError:
                        self?.simplerAlert(title: "데이터베이스 에러")
                    case .serverError:
                        self?.simplerAlert(title: "서버 에러")
                    default:
                        print("슥/삭 실패")
                    }
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    @objc private func touchUpBackButton() {
        callback?(buttonsView.isLike ?? 0)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 공유 버튼
    @objc func touchUpShareButton(){
        let adBrix = AdBrixRM.getInstance
        adBrix.event(eventName: "touchUp_Share",
                     value: ["posterIdx": posterIdx])
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        var objectsToshare: [Any] = []
        
        objectsToshare.append("슥삭 다운로드 링크")
        objectsToshare.append("\(downloadLink)\n")
        
        guard let posterName = posterDetailData?.posterName,
            let posterWebSiteURL = posterDetailData?.posterWebSite else {
                addObjects(with: objectsToshare)
                return
        }
        
        objectsToshare.append(posterName)
        objectsToshare.append(posterWebSiteURL)
        
        addObjects(with: objectsToshare)
    }
    
    @objc func handleShowKeyboard(notification: NSNotification) {
        guard let keyboardFrame
            = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect else {
                    return
        }
        
        safeAreaViewBottomConstraint.constant = -keyboardFrame.height
        self.view.layoutIfNeeded()
    }
    
    @objc func handleHideKeyboard(notification: NSNotification) {
        safeAreaViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    private func addObjects(with objectsToshare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToshare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

extension DetailInfoViewController: UICollectionViewDelegate {
    
}

extension DetailInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return .init()
        }
        
        if isTryWithoutLogin {
            return 2
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        case 2:
            return posterDetailData?.commentList?.count != 0 ? (posterDetailData?.commentList?.count ?? 0) : 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryIdx = posterDetailData?.categoryIdx else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "tempCell", for: indexPath)
        }
        
        let infoTitles = titleStringByCategory(categoryIdx: categoryIdx)
        
        switch indexPath.section {
        case 0:
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
                
                if columnData?.count ?? 3 < 1 {
                    return cell
                }
                
                if categoryIdx == 3 || categoryIdx == 5 {
                    cell.configure(titleString: columnData?[0].columnName ?? "",
                                   detailString: columnData?[0].columnContent ?? "")
                } else if posterDetailData?.categoryIdx == 8 {
                    cell.configure(titleString: infoTitles[0],
                                   detailString: posterDetailData?.benefit ?? "")
                } else {
                    cell.configure(titleString: infoTitles[0],
                                   detailString: posterDetailData?.outline ?? "")
                }
                
                return cell
            case 2:
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                         for: indexPath) as? DetailInfoCollectionViewCell else {
                                                            return .init()
                }
                
                if columnData?.count ?? 3 < 2 {
                    return cell
                }
                
                if categoryIdx == 3 || categoryIdx == 5 {
                    cell.configure(titleString: columnData?[1].columnName ?? "",
                                   detailString: columnData?[1].columnContent ?? "")
                } else if posterDetailData?.categoryIdx == 2 {
                    cell.configure(titleString: infoTitles[1],
                                   detailString: posterDetailData?.period ?? "")
                } else {
                    cell.configure(titleString: infoTitles[1],
                                   detailString: posterDetailData?.target ?? "")
                }
                return cell
            case 3:
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                         for: indexPath) as? DetailInfoCollectionViewCell else {
                                                            return .init()
                }
                
                if columnData?.count ?? 3 < 3 {
                    return cell
                }
                
                if categoryIdx == 3 || categoryIdx == 5 {
                    cell.configure(titleString: columnData?[2].columnName ?? "",
                                   detailString: columnData?[2].columnContent ?? "")
                } else if posterDetailData?.categoryIdx == 7 {
                    cell.configure(titleString: infoTitles[2],
                                   detailString: posterDetailData?.period ?? "")
                } else if posterDetailData?.categoryIdx == 8 {
                    cell.configure(titleString: infoTitles[2],
                                   detailString: posterDetailData?.outline ?? "")
                } else {
                    cell.configure(titleString: infoTitles[2],
                                   detailString: posterDetailData?.benefit ?? "")
                }
                
                return cell
            case 4:
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "contactInfoCellID",
                                                         for: indexPath) as? ContactInfoCollectionViewCell else {
                                                            return .init()
                }
                
                cell.configure(email: posterDetailData?.partnerEmail ?? "")
                
                return cell
            case 5:
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "seeMoreCellID",
                                                         for: indexPath) as? SeeMoreCollectionViewCell else {
                                                            return .init()
                }
                
                cell.configure(contents: posterDetailData?.posterDetail ?? "")
                
                return cell
            default:
                return .init()
            }
        case 1:
            guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
                return .init()
            }
            
            if isTryWithoutLogin {
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "hideAnalyticsCommentsCell",
                                                         for: indexPath) as? HideAnalyticsCommentsCollectionViewCell else {
                                                            return .init()
                }
                
                cell.callBack = {
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
                    
                    let rootNavigationController = UINavigationController(rootViewController: viewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = rootNavigationController
                    
                    rootNavigationController.view.layoutIfNeeded()
                    
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        window.rootViewController = rootNavigationController
                    }, completion: nil)
                }
                
                return cell
            }
            
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "analyticsCellID",
                                                     for: indexPath) as? AnalysticsCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(analyticsData: analyticsData)
            
            return cell
        default:
            if posterDetailData?.commentList?.count == 0 {
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "noCommentCell",
                                                         for: indexPath) as? NoCommentCollectionViewCell else {
                                                            return .init()
                }
                
                return cell
            }
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCellID",
                                                     for: indexPath) as? CommentCollectionViewCell else {
                                                        return .init()
            }
            
            guard let comment = posterDetailData?.commentList?[indexPath.item] else {
                return cell
            }
            
            cell.delegate = self
            cell.comment = comment
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard indexPath.section == 0 else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "posterHeaderID", for: indexPath) as? PosterHeaderCollectionReusableView else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            header.delegate = self
            header.detailData = posterDetailData
            
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
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "tempFooter",
                                                                   for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        currentTextField?.resignFirstResponder()
        
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                if indexPath.item == 0 {
                    // 상세 이미지
                    let detailImageView = DetailImageViewController()
                    detailImageView.titleText = posterDetailData?.posterName
                    detailImageView.urlString = posterDetailData?.photoUrl2
                    present(detailImageView, animated: true)
                }
            case 5:
                // 자세히 보기
                let indexPaths = [indexPath]
                collectionView.reloadItems(at: indexPaths)
                collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            default:
                return
            }
        default:
            return
        }
    }
}

extension DetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: view.frame.width, height: 243)
        default:
            return CGSize(width: view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                guard let _ = posterDetailData?.photoUrl2 else {
                    return CGSize(width: view.frame.width, height: 0)
                }
                return CGSize(width: view.frame.width, height: 41)
            case 1:
                if columnData?.count ?? 3 < 1 {
                    return CGSize(width: view.frame.width, height: 0)
                }
                let collectionViewCellHeight = estimatedFrame(width: view.frame.width - 75,
                                                              text: posterDetailData?.outline ?? "",
                                                              font: UIFont.systemFont(ofSize: 14)).height
                
                return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
            case 2:
                if columnData?.count ?? 3 < 2 {
                    return CGSize(width: view.frame.width, height: 0)
                }
                
                let collectionViewCellHeight = estimatedFrame(width: view.frame.width - 75,
                                                              text: posterDetailData?.target ?? "",
                                                              font: UIFont.systemFont(ofSize: 14)).height
                
                return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
            case 3:
                if columnData?.count ?? 3 < 3 {
                    return CGSize(width: view.frame.width, height: 0)
                }
                
                let collectionViewCellHeight = estimatedFrame(width: view.frame.width - 75,
                                                              text: posterDetailData?.benefit ?? "",
                                                              font: UIFont.systemFont(ofSize: 14)).height
                
                return CGSize(width: view.frame.width, height: collectionViewCellHeight + 72)
            case 4:
                guard let _ = posterDetailData?.partnerEmail else {
                    return CGSize(width: 0, height: 0)
                }
                
                return CGSize(width: view.frame.width, height: 80)
            case 5:
                if isFolding {
                    isFolding = !isFolding
                    return CGSize(width: view.frame.width, height: 46)
                } else {
                    isFolding = !isFolding
                    
                    let collectionViewCellHeight = estimatedFrame(width: view.frame.width - 75,
                                                                  text: posterDetailData?.posterDetail ?? "",
                                                                  font: UIFont.systemFont(ofSize: 12)).height
                    
                    return CGSize(width: view.frame.width, height: collectionViewCellHeight + 50 + 46)
                }
            default:
                return CGSize(width: view.frame.width, height: 0)
            }
        case 1:
            return CGSize(width: view.frame.width, height: 268)
        default:
            if posterDetailData?.commentList?.count == 0 {
                return CGSize(width: view.frame.width, height: 80)
            }
            
            let collectionViewCellHeight
                = estimatedFrame(width: view.frame.width - 48 - 74 - 28,
                                 text: posterDetailData?.commentList?[indexPath.item].commentContent ?? "",
                                 font: UIFont.systemFont(ofSize: 13)).height
            
            return CGSize(width: view.frame.width, height: collectionViewCellHeight + 12 + 8 + 20 + 10)
        }
        
    }
}

extension DetailInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailInfoViewController: UIGestureRecognizerDelegate {
}

extension DetailInfoViewController: WebsiteDelegate {
    func moveToWebsite(isApply: Bool) {
        if isApply {
            guard let applysiteURL = posterDetailData?.posterWebSite2,
                let url = URL(string: applysiteURL) else {
                    return
            }
            UIApplication.shared.open(url)
        } else {
            let adBrix = AdBrixRM.getInstance
            adBrix.event(eventName: "touchUp_MoveToWebsite",
                         value: ["posterIdx": posterIdx])
            
            guard let websiteURL = posterDetailData?.posterWebSite,
                let url = URL(string: websiteURL) else {
                    return
            }
            UIApplication.shared.open(url)
        }
    }
}

extension DetailInfoViewController: CommentWriteDelegate {
    func commentRegister(text: String) {
        guard let index = posterIdx else {
            return
        }
        
        commentServiceImp.requestAddComment(index: index,
                                            comment: text) { [weak self] result in
                                                switch result {
                                                case .success(let status):
                                                    switch status {
                                                    case .secondSucess:
                                                        DispatchQueue.main.async {
                                                            self?.currentTextField?.resignFirstResponder()
                                                            self?.simplerAlert(title: "댓글 등록이 완료되었습니다.")
                                                            self?.isFolding = true
                                                            self?.requestDatas(section: 2)
                                                        }
                                                    case .dataBaseError:
                                                        DispatchQueue.main.async {
                                                            self?.simplerAlert(title: "database error")
                                                        }
                                                        return
                                                    case .serverError:
                                                        DispatchQueue.main.async {
                                                            self?.simplerAlert(title: "server error")
                                                        }
                                                        return
                                                    default:
                                                        return
                                                    }
                                                case .failed(let error):
                                                    print(error)
                                                    return
                                                }
        }
    }
}

extension DetailInfoViewController: CommentDelegate {
    
    func touchUpCommentLikeButton(index: Int, like: Int) {
        commentServiceImp.requestCommentLike(index: index,
                                             like: like) { [weak self] result in
                                                switch result {
                                                case .success(let status):
                                                    DispatchQueue.main.async {
                                                        switch status {
                                                        case .processingSuccess:
                                                            self?.requestDatas(section: 2)
                                                            self?.isFolding = true
                                                        case .dataBaseError:
                                                            self?.simplerAlert(title: "database error")
                                                            return
                                                        case .serverError:
                                                            self?.simplerAlert(title: "server error")
                                                            return
                                                        default:
                                                            return
                                                        }
                                                    }
                                                case .failed(let error):
                                                    print(error)
                                                    return
                                                }
        }
    }
    
    func presentAlertController(_ isMine: Bool, commentIndex: Int) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        if isMine {
            //            let editAction = UIAlertAction(title: "댓글 수정", style: .default) { [weak self] _ in
            //
            //            }
            
            let deleteAction = UIAlertAction(title: "댓글 삭제", style: .default) { [weak self] _ in
                self?.commentServiceImp.requestCommentDelete(index: commentIndex) { [weak self] result in
                    switch result {
                    case .success(let status):
                        DispatchQueue.main.async {
                            switch status {
                            case .processingSuccess:
                                self?.simplerAlert(title: "댓글이 삭제되었습니다")
                                self?.isFolding = true
                                self?.requestDatas(section: 2)
                            case .dataBaseError:
                                self?.simplerAlert(title: "database error")
                                return
                            case .serverError:
                                self?.simplerAlert(title: "server error")
                                return
                            default:
                                return
                            }
                        }
                    case .failed(let error):
                        print(error)
                        return
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            }
            
            //            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        } else {
            
            let reportAction = UIAlertAction(title: "댓글 신고", style: .default) { [weak self] _ in
                self?.commentServiceImp.requestCommentReport(index: commentIndex) { [weak self] result in
                    switch result {
                    case .success(let status):
                        DispatchQueue.main.async {
                            switch status {
                            case .processingSuccess:
                                self?.simplerAlert(title: "댓글 신고가 완료되었습니다.")
                            case .dataBaseError:
                                self?.simplerAlert(title: "database error")
                                return
                            case .serverError:
                                self?.simplerAlert(title: "server error")
                                return
                            default:
                                return
                            }
                        }
                    case .failed(let error):
                        print(error)
                        return
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            }
            
            alertController.addAction(reportAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
}

extension DetailInfoViewController: LargeImageDelegate {
    func presentLargeImage() {
        let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
                                           bundle: nil)
        guard let zoomPosterVC = swipeStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.zoomPosterViewController) as? ZoomPosterVC else {return}
        
        zoomPosterVC.urlString = posterDetailData?.photoUrl
        
        self.present(zoomPosterVC, animated: true)
    }
}

func titleStringByCategory(categoryIdx: Int) -> [String] {
    switch categoryIdx {
    case 0:
        // 공모전
        return ["주제", "지원자격", "시상내역"]
    case 1:
        // 대외활동
        return ["지원자격", "활동내용", "혜택"]
    case 2:
        // 동아리
        return ["활동분야", "모임시간", "활동혜택"]
    case 3:
        // 교내공지
        return ["활동분야", "모임시간", "혜택"]
    case 4:
        // 인턴
        return ["모집분야", "지원자격", "근무조건"]
    case 5:
        // 기타
        return ["", "", ""]
    case 7:
        // 교육/강연
        return ["주제", "내용/커리큘럼", "일정/기간"]
    case 8:
        // 장학금/지원
        return ["인원/혜택", "대상 및 조건", "기타사항"]
    default:
        return ["항목1", "항목2", "항목3"]
    }
}
