//
//  PageViewController.swift
//  PageControl
//
//  Created by Andrew Seeley on 2/2/17.
//  Copyright © 2017 Seemu. All rights reserved.
//

import UIKit
import CoreMedia

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, SegmentedProgressBarDelegate {
    var pageIndex : Int = 0
    var SPB: SegmentedProgressBar!
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "sbBlue"),
                self.newVc(viewController: "sbRed")]
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        SPB = SegmentedProgressBar(numberOfSegments: 2)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        //SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(tapGestureImage)
        //imagePreview.addGestureRecognizer(tapGestureImage)
       
        // This sets up the first view that will show up on our page control
        
        
       // configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
    }
    //2
    func segmentedProgressBarFinished() {
        if pageIndex == (2 - 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        SPB.skip()
        
        print(sender.numberOfTapsRequired)
        if sender.numberOfTapsRequired == 1 {
            addChild(orderedViewControllers[1])
            view.addSubview(orderedViewControllers[1].view)
            orderedViewControllers[1].didMove(toParent: self)
            sender.numberOfTapsRequired = -1
        }else {
            
            dismiss(animated: true, completion: nil)
            sender.numberOfTapsRequired = 1
        }
        //present(orderedViewControllers[1], animated: true, completion: nil)
        
        //let pageContentViewController = self.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: self.viewControllers![0])!
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
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Tinder", bundle: nil).instantiateViewController(withIdentifier: viewController)
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
