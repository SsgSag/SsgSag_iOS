//
//  PageViewController.swift
//  PageControl
//
//  Created by Andrew Seeley on 2/2/17.
//  Copyright © 2017 Seemu. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, SegmentedProgressBarDelegate {
    var pageIndex : Int = 0
    var SPB: SegmentedProgressBar!
    var pageControl = UIPageControl()
    var pageStatus: Int = 1
    
    // MARK: UIPageViewControllerDataSource
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "DetailText"),
                self.newVC(viewController: "DetailImage")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        view.addSubview(orderedViewControllers[0].view)
        view.addSubview(orderedViewControllers[1].view)
    
        SPB = SegmentedProgressBar(numberOfSegments: 2)
        
//        view.addSubview(SPB)
       // TODO: else frame 수정
//        if #available(iOS 11.0, *) {
//            SPB.frame = CGRect(x: 10, y:0, width: view.frame.width - 25, height: 3)
//        } else {
//            // Fallback on earlier versions
//            SPB.frame = CGRect(x: 10, y: 0, width: view.frame.width - 35, height: 3)
//        }
        
        SPB.delegate = self
        SPB.topColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        
        //SPB.padding = 10
        SPB.currentAnimationIndex = 0

    
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        //SPB 오토 레이
        SPB.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SPB.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        SPB.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        SPB.heightAnchor.constraint(equalToConstant: 3).isActive = true
        SPB.translatesAutoresizingMaskIntoConstraints = false
        
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGestureImage)
        
       // print("pagestatussssssss:\(pageStatus)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
        //print("changedIndex\(index)")
    }
    
    func segmentedProgressBarFinished() {
        print("segmentedProgressBarFinished 끝나벌여~")

    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        self.view.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭")
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if pageIndex == 0 {
            SPB.skip()
            pageIndex = pageIndex + 1
        } else {
            pageIndex = 0
            SPB.rewind()
        }
        if pageStatus == 1{
            orderedViewControllers[0].view.isHidden = false
            orderedViewControllers[1].view.isHidden = true
            pageStatus = -1
        } else {
            orderedViewControllers[0].view.isHidden = true
            orderedViewControllers[1].view.isHidden = false
            pageStatus = 1
        }
        
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
//        if [index].type == "image" {
//            self.imagePreview.isHidden = false
//            self.imagePreview.imageFromServerURL(item[index].url)
//        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.blue
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "SwipeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
}
