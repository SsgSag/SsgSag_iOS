//
//  SplashVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 4..
//  Copyright © 2019년 wndzlf. All rights reserved.
//
import UIKit

class SplashVC: UIViewController {
    
//    @IBOutlet var splashGifImg: UIImageView!
    
//    let ud = UserDefaults.standard
//    let delayInSeconds = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradient(from: .red, to: .blue)
//        setupGif()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
//            if let _ = self.ud.string(forKey: "tutorial") {
//                if let auto = self.ud.string(forKey: "autologin") {
//                    //서버통신해서 유효한지 확인하기
//                } else {
//                    guard let dvc = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")  as? SignInVC else { return }
//                    self.present(dvc, animated: true)
//                }
//            } else {
//                guard let dvc = UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "Tutorial1")  as? Tutorial1VC else { return }
//                dvc.hero.modalAnimationType = .zoom
//                self.present(dvc, animated: true)
//            }
//        }
//        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupGif() {
//        let gifManager = SwiftyGifManager(memoryLimit:20)
//        let gif = UIImage(gifName: "ios_splash.gif")
//        self.splashGifImg.setGifImage(gif, manager: gifManager, loopCount: 1)
//    }
    
    
}

