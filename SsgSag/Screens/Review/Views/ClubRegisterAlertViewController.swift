//
//  ClubRegisterAlertViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubRegisterAlertViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    let locations = ClubAbout.locations
    let categorys = ClubAbout.categorys
    var model: ClubRegisterModel!
    var type: InputType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension ClubRegisterAlertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActLocationCell", for: indexPath) as! ActLocationTableViewCell
        let title = type == InputType.location ? self.locations[safe: indexPath.row] : self.categorys[safe: indexPath.row]
        
        cell.locationLabel.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActLocationTableViewCell
        guard let title = cell.locationLabel.text else {return}
        
        type == InputType.location ? model.univOrLocation = title : model.category.append(title)
        // dismiss anim
    }
}
