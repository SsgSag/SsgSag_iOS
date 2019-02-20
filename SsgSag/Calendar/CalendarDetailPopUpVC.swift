//
//  CalendarDetailInfoVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 20/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailPopUpVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var detailTextView: UITextView!
    
    var websiteURL: String?
    var posterDetailText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.applyRadius(radius: 4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let posterDetail = posterDetailText {
            detailTextView.text = posterDetail
        }
    }
    
    @IBAction func touchUpWebsite(sender: UIButton) {
        
        if let webURL = websiteURL {
            print("weburl: \(webURL)")
            if #available(iOS 10, *) {
                UIApplication.shared.open(URL(string: webURL)!)
            }
            UIApplication.shared.openURL(URL(string: webURL)!)
        }
        
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
