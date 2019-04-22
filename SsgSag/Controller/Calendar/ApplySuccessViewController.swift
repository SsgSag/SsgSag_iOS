//
//  ApplySuccessViewController.swift
//  SsgSag
//
//  Created by admin on 22/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ApplySuccessViewController: UIViewController {
    
    var posters: [Posters]? {
        didSet {
            guard let posters = posters else { return }
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func moveToCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
    }
}

//extension ApplySuccessViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return init()
//    }
//}
