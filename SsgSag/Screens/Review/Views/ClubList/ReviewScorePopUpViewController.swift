//
//  ReviewScorePopUpViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/12.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewScorePopUpViewController: UIViewController {

    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var viewBottomLayout: NSLayoutConstraint!
    
    private let viewHeight: CGFloat = 600
    private let hideBotViewHeight: CGFloat = 419
    private var isDismiss = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        isDismiss ? disAppearAnim() : appearAnim()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == eventView {
            return
        }
        disAppearAnim()
    }
    
    func appearAnim() {
        self.viewBottomLayout.constant = hideBotViewHeight - viewHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func disAppearAnim() {
        self.viewBottomLayout.constant = -self.viewHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        dismiss(animated: true)
    }
    
    @IBAction func okClick(_ sender: Any) {
        let nextVC = UIStoryboard(name: StoryBoardName.review, bundle: nil).instantiateViewController(withIdentifier: "ReviewPrepareVC")
        isDismiss = true
        self.present(nextVC, animated: true)
    }
    
}
