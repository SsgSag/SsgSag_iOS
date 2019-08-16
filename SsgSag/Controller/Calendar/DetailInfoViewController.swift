//
//  DetailInfoViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DetailInfoViewController: UIViewController {

    private var posterServiceImp: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    private var commentServiceImp: CommentService
        = DependencyContainer.shared.getDependency(key: .commentService)
    
    var currentTextField: UITextField?
    var callback: ((Int) -> ())?
    var posterIdx: Int?
    var posterDetailData: DataClass?
    private var isFolding: Bool = false
    
    let downloadLink = "https://ssgsag.page.link/install"
    
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
    
    lazy var buttonsView: DetailInfoButtonsView = {
        let view = DetailInfoButtonsView()
        view.delegate = self
        view.callback = { [weak self] in
            self?.requestDatas()
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
    
    private func requestDatas() {
        guard let posterIdx = posterIdx else { return }
        
        posterServiceImp.requestPosterDetail(posterIdx: posterIdx) { [weak self] response in
            switch response {
            case .success(let detailData):
                self?.posterDetailData = detailData
                self?.buttonsView.posterIndex = posterIdx
                self?.buttonsView.isLike = detailData.isFavorite
                self?.buttonsView.isExistApplyURL = detailData.posterWebSite2 != nil ? true : false
                
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
        
        let hideNib = UINib(nibName: "HideAnalyticsCommentsCollectionViewCell", bundle: nil)
        
        infoCollectionView.register(hideNib, forCellWithReuseIdentifier: "hideAnalyticsCommentsCell")
        
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
        callback?(buttonsView.isLike ?? 0)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 공유 버튼
    @objc func touchUpShareButton(){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        var objectsToshare: [Any] = []
        
        objectsToshare.append("슥삭 다운로드 링크")
        
        objectsToshare.append("\(downloadLink)\n")
        
        guard let posterName = posterDetailData?.posterName else {return}
        
        objectsToshare.append(posterName)
        
        guard let posterWebSiteURL = posterDetailData?.posterWebSite else {
            addObjects(with: objectsToshare)
            return
        }
        
        objectsToshare.append(posterWebSiteURL)
        
        addObjects(with: objectsToshare)
    }
    
    @objc func handleShowKeyboard(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        infoCollectionView.setContentOffset(CGPoint(x: 0, y: infoCollectionView.contentOffset.y + keyboardFrame.height - buttonsView.frame.height - safeAreaView.frame.height), animated: true)
    }
    
    @objc func handleHideKeyboard(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        infoCollectionView.setContentOffset(CGPoint(x: 0, y: infoCollectionView.contentOffset.y - keyboardFrame.height + buttonsView.frame.height + safeAreaView.frame.height), animated: true)
    }
    
    private func addObjects(with objectsToshare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToshare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func titleStringByCategory() -> [String] {
        switch posterDetailData?.categoryIdx {
        case 0:
            // 공모전
            return ["주제", "지원자격", "시상내역"]
        case 1:
            // 대외활동
            return ["지원자격", "활동내용", "활동혜택"]
        case 2:
            // 동아리(연합)
            return ["활동분야", "모임시간", "활동혜택"]
        case 3:
            // 교내공지
            return ["활동분야", "모임시간", "혜택"]
        case 4:
            // 인턴
            return ["모집분야", "지원자격", "근무지역"]
        case 5:
            // 기타
            return ["", "", ""]
        case 6:
            // 동아리 (교내)
            return ["활동분야", "모임시간", "활동혜택"]
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
    
}

extension DetailInfoViewController: UICollectionViewDelegate {
    
}

extension DetailInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return .init()
        }
        
        if isTryWithoutLogin {
            return 7
        } else {
            return 8 + (posterDetailData?.commentList?.count ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let infoTitles = titleStringByCategory()
        
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
            
            cell.configure(titleString: infoTitles[0],
                           detailString: posterDetailData?.outline ?? "")
            
            return cell
        case 2:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                     for: indexPath) as? DetailInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(titleString: infoTitles[1],
                           detailString: posterDetailData?.target ?? "")
            
            return cell
        case 3:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCellID",
                                                     for: indexPath) as? DetailInfoCollectionViewCell else {
                                                        return .init()
            }
            
            cell.configure(titleString: infoTitles[2],
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
            
            cell.configure(analyticsData: posterDetailData?.analytics)
            
            return cell
            
        case 8 + (posterDetailData?.commentList?.count ?? 0) - 1:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "commentWriteCellID",
                                                     for: indexPath) as? CommentWriteCollectionViewCell else {
                                                        return .init()
            }
            
            cell.delegate = self
            cell.commentWriteTextField.delegate = self
            
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
            
            cell.delegate = self
            cell.comment = comment
            
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
            
            header.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        currentTextField?.resignFirstResponder()
        
        switch indexPath.item {
        case 0:
            // 상세 이미지
            let detailImageView = DetailImageViewController()
            detailImageView.titleText = posterDetailData?.posterName
            detailImageView.urlString = posterDetailData?.photoUrl2
            present(detailImageView, animated: true)
        case 5:
            // 자세히 보기
            let indexPaths = [indexPath]
            collectionView.reloadItems(at: indexPaths)
        default:
            return
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            guard let _ = posterDetailData?.photoUrl2 else {
                return CGSize(width: view.frame.width, height: 0)
            }
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
            return CGSize(width: view.frame.width, height: 268)
        case 8 + (posterDetailData?.commentList?.count ?? 0) - 1:
            return CGSize(width: view.frame.width, height: 46)
        default:
            
//            let collectionViewCellHeight = estimatedFrame(text: posterDetailData?.posterDetail ?? "",
//                                                          font: UIFont.systemFont(ofSize: 12)).height
//            
//            return CGSize(width: view.frame.width, height: collectionViewCellHeight + 50 + 46)
            return CGSize(width: view.frame.width, height: 65)
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

extension DetailInfoViewController: WebsiteDelegate {
    func moveToWebsite(isApply: Bool) {
        if isApply {
            guard let applysiteURL = posterDetailData?.posterWebSite2,
                let url = URL(string: applysiteURL) else {
                return
            }
            UIApplication.shared.open(url)
        } else {
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
                        self?.requestDatas()
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
                        self?.requestDatas()
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
    
    func presentAlertController(index: Int) {
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "댓글 삭제", style: .default) { [weak self] _ in
            self?.commentServiceImp.requestCommentDelete(index: index) { [weak self] result in
                switch result {
                case .success(let status):
                    DispatchQueue.main.async {
                        switch status {
                        case .processingSuccess:
                            self?.simplerAlert(title: "댓글이 삭제되었습니다")
                            self?.isFolding = true
                            self?.requestDatas()
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
        
        let reportAction = UIAlertAction(title: "댓글 신고", style: .default) { [weak self] _ in
            self?.commentServiceImp.requestCommentReport(index: index) { [weak self] result in
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
        
        alertController.addAction(deleteAction)
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension DetailInfoViewController: LargeImageDelegate {
    func presentLargeImage() {
//        let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
//                                           bundle: nil)
//        guard let zoomPosterVC = swipeStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.zoomPosterViewController) as? ZoomPosterVC else {return}
//        
//        zoomPosterVC.urlString = posterDetailData?.photoUrl
//        
//        self.present(zoomPosterVC, animated: true, completion: nil)
    }
}
