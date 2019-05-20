//
//  CalendarDetailVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailVC: UIViewController {

    var Poster: Posters?
    
    @IBOutlet var PosterImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hashTagLabel: UILabel!
    
    @IBOutlet weak var titlePeriodLabel: UILabel!
    
    @IBOutlet var outLineLabel: UILabel!
    
    @IBOutlet var benefitLabel: UILabel!
    
    @IBOutlet var targetLabel: UILabel!
  
    @IBOutlet weak var seeDetailButton: UIButton!
    
    let hashTags: [Int: String] = [0: "기획/아이디어", 1:"금융/경제", 2:"디자인", 3:"문학/글쓰기", 4:"문화/예술", 5:"브랜딩/마케팅", 6:"봉사/사회활동", 7:"사진/영상", 8:"창업/스타트업", 9:"체육/건강", 10:"학술/교양", 11:"IT/기술"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPosterContent()
        
    }
    
    private func setPosterContent() {
        if let photoURL = Poster?.photoUrl {
            if let url = URL(string: photoURL){
                PosterImage.load(url: url)
            }
        }
        
        if let poster = Poster {
            
            if let category : PosterCategory = PosterCategory(rawValue: poster.categoryIdx!) {
                categoryLabel.text = category.categoryString()
                categoryLabel.textColor = category.categoryColors()
                titlePeriodLabel.textColor = category.categoryColors()
                
                titlePeriodLabel.text = poster.keyword
            }
            
            nameLabel.text = poster.posterName
            outLineLabel.text = poster.outline
            targetLabel.text = poster.target
            benefitLabel.text = poster.benefit
            
            if let posterInterest = poster.posterInterest {
                
                var hashTagString = ""
                for hashInterest in posterInterest {
                    if let hashTagsHashInterest = hashTags[hashInterest] {
                        hashTagString = hashTagString + "#" + hashTagsHashInterest + " "
                    }
                }
                hashTagLabel.text = hashTagString
            }
        }
    }
    
    @IBAction func touchUpShareButton(_ sender: Any) {
        share(sender:view)
    }
    
    
    @IBAction func moveToWebsite(_ sender: Any) {
        
        guard let websiteURL = Poster?.posterWebSite else {
            return
        }
        
        guard let url = URL(string: websiteURL) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        var objectsToshare: [Any] = []
        
        guard let posterName = Poster?.posterName else {return}
        
        objectsToshare.append(posterName)
        
        guard let posterImage = PosterImage.image else {
            addObjects(with: objectsToshare, sender: sender)
            return
        }
        
        objectsToshare.append(posterImage)
        
        guard let posterWebSiteURL = Poster?.posterWebSite else {
            addObjects(with: objectsToshare, sender: sender)
            return
        }
        
        objectsToshare.append(posterWebSiteURL)
        
        addObjects(with: objectsToshare, sender: sender)
        
    }
    
    private func addObjects(with objectsToshare: [Any], sender: UIView) {
        let activityVC = UIActivityViewController(activityItems: objectsToshare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList ]
        
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
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
        let storyBoard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
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
