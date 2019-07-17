//
//  CalendarDetailVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailVC: UIViewController {
    
//    var Poster: Posters?
    var Poster: DayTodoData?
    var posterDetail: DataClass?
    
    static let downloadLink = "https://itunes.apple.com/kr/app/%EC%8A%A5%EC%82%AD/id1457422029?mt=8"
    
    @IBOutlet weak var detailImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seeMoreHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var PosterImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hashTagTextView: UITextView!
    
    @IBOutlet weak var titlePeriodLabel: UILabel!
    
    @IBOutlet weak var outLineLabel: UILabel!
    
    @IBOutlet weak var benefitLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var partnerPhoneNumLabel: UILabel!
    
    @IBOutlet weak var partnerEmailLabel: UILabel!
    
    @IBOutlet weak var seeMoreView: UIView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var likedButton: UIButton!
    
    @IBOutlet weak var contactInfoHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seeMoreLabel: UILabel!
    
    private var posterServiceImp: PosterService?
    
    private var isFolding: Bool = true

    let hashTags: [Int: String] = [0: "기획/아이디어",
                                   1:"금융/경제",
                                   2:"디자인",
                                   3:"문학/글쓰기",
                                   4:"문화/예술",
                                   5:"브랜딩/마케팅",
                                   6:"봉사/사회활동",
                                   7:"사진/영상",
                                   8:"창업/스타트업",
                                   9:"체육/건강",
                                   10:"학술/교양",
                                   11:"IT/기술"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        seeMoreHeightConstraint.isActive = false
        seeMoreHeightConstraint = seeMoreView.heightAnchor.constraint(equalToConstant: 0)
        seeMoreHeightConstraint.isActive = true
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        hashTagTextView.textContainer.lineFragmentPadding = 0
        hashTagTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setPosterContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setPosterContent(_ posterService: PosterService = PosterServiceImp()) {
        
        if let poster = Poster {
            
            self.posterServiceImp = posterService
            
            guard let posterIdx = poster.posterIdx else { return }
            
            posterServiceImp?.requestPosterDetail(posterIdx: posterIdx) { [weak self] dataResponse in
                switch dataResponse {
                case .success(let detailData):
                    self?.posterDetail = detailData
                    
                    if let photoURL = detailData.photoUrl {
                        if let url = URL(string: photoURL){
                            ImageNetworkManager.shared.getImageByCache(imageURL: url) { image, error in
                                DispatchQueue.main.async { [weak self] in
                                    self?.PosterImage.image = image
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        guard let categoryIdx = detailData.categoryIdx else { return }
                        
                        if let category = PosterCategory(rawValue: categoryIdx) {
                            self?.categoryButton.setTitle(category.categoryString(), for: .normal)
                            self?.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
                            self?.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
                        }
                        
                        if categoryIdx != 4 {
                            self?.detailImageHeightConstraint.constant = 0
                        }
                        
//                        self?.favoriteButton.setTitle(favoriteString, for: .normal)
//                        self?.likedButton.setTitle(likeString, for: .normal)
                        
                        if detailData.partnerPhone == nil && detailData.partnerEmail == nil {
                            self?.contactInfoHeightConstraint.constant = 0
                        }
                        
                        if let partnerPhone = detailData.partnerPhone {
                            self?.partnerPhoneNumLabel.text = "전화번호: " + partnerPhone
                        }
                        
                        if let partnerEmail = detailData.partnerEmail {
                            self?.partnerEmailLabel.text = "이메일: " + partnerEmail
                        }
                        
                        self?.titlePeriodLabel.text
                            = DateCaculate.getDifferenceBetweenStartAndEnd(startDate: detailData.posterStartDate, endDate: detailData.posterEndDate)
                        self?.hashTagTextView.text = detailData.keyword
                        
                        self?.nameLabel.text = detailData.posterName
                        self?.outLineLabel.text = detailData.outline
                        self?.targetLabel.text = detailData.target
                        self?.benefitLabel.text = detailData.benefit
                        self?.seeMoreLabel.text = detailData.posterDetail
                        
                    }
                case .failed(let error):
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func touchUpShareButton(_ sender: Any) {
        share(sender: view)
    }
    
    
    @IBAction func moveToWebsite(_ sender: Any) {
        
        guard let websiteURL = posterDetail?.posterWebSite else {
            return
        }

        guard let url = URL(string: websiteURL) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - 공유 버튼
    @objc func share(sender: UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        var objectsToshare: [Any] = []
        
        objectsToshare.append("다운로드 링크")
        
        objectsToshare.append(CalendarDetailVC.downloadLink)
        
        guard let posterName = Poster?.posterName else {return}
        
        objectsToshare.append(posterName)
        
        guard let posterImage = PosterImage.image else {
            addObjects(with: objectsToshare, sender: sender)
            return
        }
        
        objectsToshare.append(posterImage)
        
        guard let posterWebSiteURL = posterDetail?.posterWebSite else {
            addObjects(with: objectsToshare, sender: sender)
            return
        }
        
        objectsToshare.append(posterWebSiteURL)
        
        addObjects(with: objectsToshare, sender: sender)
    }
    
    private func addObjects(with objectsToshare: [Any], sender: UIView) {
        let activityVC = UIActivityViewController(activityItems: objectsToshare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func touchUpDetailButton(_ sender: UIButton) {
        popUpDetailInfo(button: sender)
    }
    
    @IBAction func touchUpFavoriteButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "ic_favoriteWhiteBoxPassive") {
            sender.setImage(UIImage(named: "ic_favoriteWhiteBox"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_favoriteWhiteBoxPassive"), for: .normal)
        }
    }
    
    @IBAction func touchUpSeeMoreButton(_ sender: UIButton) {
        if isFolding {
            seeMoreHeightConstraint.isActive = false
            seeMoreHeightConstraint = seeMoreView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
            seeMoreHeightConstraint.isActive = true
        } else {
            seeMoreHeightConstraint.isActive = false
            seeMoreHeightConstraint = seeMoreView.heightAnchor.constraint(equalToConstant: 0)
            seeMoreHeightConstraint.isActive = true
        }

        isFolding = !isFolding
        
        view.layoutIfNeeded()
    }
    
    @IBAction func touchUpBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC: ZoomPosterImageVC = segue.destination as? ZoomPosterImageVC else { return }
        nextVC.poster = PosterImage.image
    }
    
    func popUpDetailInfo(button: UIButton) {
        let storyBoard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
        let popVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.calendarDetailPopUpViewController) as! CalendarDetailPopUpVC
        
        if let poster = posterDetail {
//            popVC.websiteURL = poster.posterWebSite
//            popVC.posterDetailText = poster.posterDetail
        }
        
        present(popVC, animated: true)
    }
    
}

extension UIApplication {
    
    class var topViewController: UIViewController? {
        return getTopViewController()
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Equatable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
