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
        profileBarButton.tintColor = .cornFlower
        
        let categoryButtonView = UINib(nibName: "MainNavigationBarCenterButtonView",
                                       bundle: nil).instantiate(withOwner: self,
                                                                options: nil).first as? MainNavigationBarCenterButtonView
        categoryButtonView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        categoryButtonView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        categoryButtonView?.userpressed(type: .total)

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
        setViewControllers([totalInfoViewController], animated: false)
        totalInfoViewController.navigationItem.leftBarButtonItem = profileBarButton
        
        
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
        myFilterService.fetchMyFilterSetting()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] setting in
                guard let self = self else { return }
                let myBoard = UIStoryboard(name: "MyPageStoryBoard",
                                               bundle: nil)
                guard let myVC
                        = myBoard.instantiateViewController(withIdentifier: "MyFilterSettingViewController") as? MyFilterSettingViewController else { return }
                myVC.reactor = MyFilterSettingViewReactor(jobKind: ["개발자", "디자이너", "기획자", "마케터", "기타"],
                                                              interestedField: ["서포터즈", "봉사활동", "기획/아이디어","광고/마케팅", "디자인","영상/콘텐츠", "IT/공학", "창업/스타트업", "금융/경제"],
                                                              maxGrade: 5, initialSetting: setting)
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
