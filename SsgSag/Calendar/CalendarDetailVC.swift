//
//  CalendarDetailVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailVC: UIViewController {

    @IBOutlet var PosterImage: UIImageView!
    var Poster: Posters?
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var categoryColorView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var titlePeriodLabel: UILabel!
    
    @IBOutlet weak var recruitPeriodLabel: UILabel!
    @IBOutlet weak var actionPeriodLabel: UILabel!
    
    @IBOutlet var outLineLabel: UILabel!
    @IBOutlet var benefitLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
  
    @IBOutlet weak var seeDetailButton: UIButton!
    
    let hashTags: [Int: String] = [0: "기획/아이디어", 1:"금융/경제", 2:"디자인", 3:"문학/글쓰기", 4:"문화/예술", 5:"브랜딩/마케팅", 6:"봉사/사회활동", 7:"사진/영상", 8:"창업/스타트업", 9:"체육/건강", 10:"학술/교양", 11:"IT/기술"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoURL = Poster?.photoUrl {
            if let url = URL(string: photoURL){
                PosterImage.load(url: url)
            }
        }
        

        if let poster = Poster {
            
            if let category : PosterCategory = PosterCategory(rawValue: poster.categoryIdx!) {
                categoryLabel.text = category.categoryString()
                categoryLabel.textColor = category.categoryColors()
                categoryColorView.backgroundColor =  category.categoryColors()
            }
            nameLabel.text = poster.posterName
            recruitPeriodLabel.text = poster.documentDate
            actionPeriodLabel.text = poster.period
            outLineLabel.text = poster.outline
            targetLabel.text = poster.target
            benefitLabel.text = poster.benefit
            
            if let posterInterest = poster.posterInterest {
                var hashTagString = ""
                for hashInterest in posterInterest {
                    hashTagString = hashTagString + "#" + hashTags[hashInterest]! + " "
                }
                hashTagLabel.text = hashTagString
            }
        }
        
        if let period = recruitPeriodLabel.text {
            titlePeriodLabel.text = "기간 | " +  period
        }
        
        
      

    
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        scrollView.layoutIfNeeded()
//        let scrollViewHeight = seeDetailButton.frame.origin.y + seeDetailButton.frame.height
//        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollViewHeight + 30)
//    }
//
//
    
    @IBAction func touchUpShareButton(_ sender: Any) {
        share(sender:view)
    }
    
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out my app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.mail
            ]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpDetailButton(_ sender: UIButton) {
        popUpDetailInfo(button: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC: ZoomPosterImageVC = segue.destination as? ZoomPosterImageVC else {return}
        //FIXME: - 기본 이미지
        nextVC.poster = PosterImage.image ?? #imageLiteral(resourceName: "1")
    }
    
    func popUpDetailInfo(button: UIButton) {
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        let popVC = storyBoard.instantiateViewController(withIdentifier: "CalendarDetailPopUpVC") as! CalendarDetailPopUpVC
        self.addChild(popVC)
        popVC.view.frame = self.view.frame
        
        if let poster = Poster {
            popVC.websiteURL = poster.posterWebSite
            popVC.posterDetailText = poster.posterDetail
        }
        
        self.view.addSubview(popVC.view)
        
        popVC.didMove(toParent: self)
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
