//
//  MainViewNavigationController.swift
//  SsgSag
//
//  Created by bumslap on 07/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import FBSDKCoreKit

class MainViewNavigationController: UINavigationController {
    let myFilterService = MyFilterApiServiceImp()
    let userInfoService = UserInfoServiceImp()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewChildControllers()
        navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
    }
    
    func setUpViewChildControllers() {
        //Navibar
        navigationBar.shadowImage = UIImage()
        
        //ButtonItems
        let filterImage = UIImage(named: "filter")
         
        let filterBarButton =  UIBarButtonItem(image: filterImage,
                                   style: .done, target: self,
                                   action: #selector(touchUpFilterButton))
        filterBarButton.tintColor = .unselectedGray
        
        let profileImage = UIImage(named: "profile")
         
        let profileBarButton =  UIBarButtonItem(image: profileImage,
                                   style: .done, target: self,
                                   action: #selector(touchUpProfileButton))
        profileBarButton.tintColor = .unselectedButtonDefault
        
        let categoryButtonView = UINib(nibName: "MainNavigationBarCenterButtonView",
                                       bundle: nil).instantiate(withOwner: self,
                                                                options: nil).first as? MainNavigationBarCenterButtonView
        categoryButtonView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        categoryButtonView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        categoryButtonView?.userpressed(type: .recommend)

        //SwipeViewController
        let swipeStoryBoard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
        let swipeViewController = swipeStoryBoard.instantiateViewController(withIdentifier: "Swipe")
        swipeViewController.navigationItem.titleView = categoryButtonView
        swipeViewController.navigationItem.leftBarButtonItem = profileBarButton
        swipeViewController.navigationItem.rightBarButtonItem = filterBarButton
        
        //TotalInfoViewController
        let mainStoryBoard = UIStoryboard(name: "MainViewStoryboard",
                                                   bundle: nil)
        guard let totalInfoViewController
            = mainStoryBoard.instantiateViewController(withIdentifier: "TotalInformationViewController") as? TotalInformationViewController else { return }
               totalInfoViewController.reactor = TotalInformationReactor()
        
        totalInfoViewController.navigationItem.titleView = categoryButtonView
        setViewControllers([swipeViewController], animated: false)
        totalInfoViewController.navigationItem.leftBarButtonItem = profileBarButton
        totalInfoViewController.navigationItem.rightBarButtonItem = filterBarButton
        
        
        //setButtonClosure
        categoryButtonView?.recommendViewButtonHandler = { [weak self] in
            AppEvents.logEvent(.subscribe)
            self?.setViewControllers([swipeViewController], animated: false)
        }
                  
        categoryButtonView?.totalViewButtonnHandler = { [weak self] in
            self?.setViewControllers([totalInfoViewController], animated: false)
        }
        
    }
    
    func setViews() {

    }
    
    @objc func touchUpFilterButton() {
        Observable.zip(myFilterService.fetchMyFilterSetting(),
            userInfoService.fetchUserInfo())
            .map { (filterSetting: $0.0,
                    userInfo: [$0.1.userUniv ?? "", $0.1.userMajor ?? ""]) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] initialInfo in
                guard let self = self else { return }
                let myBoard = UIStoryboard(name: "MyPageStoryBoard",
                                               bundle: nil)
                guard let myVC
                        = myBoard.instantiateViewController(withIdentifier: "MyFilterSettingViewController") as? MyFilterSettingViewController else { return }
                myVC.reactor = MyFilterSettingViewReactor(myInfo: initialInfo.userInfo,
                                                              interestedField: ["서포터즈",
                                                                                "봉사활동",
                                                                                "기획/아이디어",
                                                                                "광고/마케팅",
                                                                                "디자인","영상/콘텐츠",
                                                                                "IT/공학",
                                                                                "창업/스타트업",
                                                                                "금융/경제"],
                                                              interestedJob:["대기업",
                                                                             "중견기업",
                                                                             "강소기업",
                                                                             "공사/공기업",
                                                                             "외국계기업",
                                                                             "스타트업",
                                                                             "정부/지방자치단체",
                                                                             "비영리단체/재단",
                                                                             "기타단체"],
                                                              initialSetting: initialInfo.filterSetting)
                if let swipeViewController = self.viewControllers.first as? SwipeVC {
                     myVC.callback = { [weak swipeViewController] in
                        swipeViewController?.requestPoster(isFirst: false)
                    }
                }
                self.pushViewController(myVC, animated: true)
            })
            .disposed(by: disposeBag)
    
    }
    
    @objc func touchUpProfileButton() {
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        present(myPageViewNavigator,
                animated: true)
    }
}
