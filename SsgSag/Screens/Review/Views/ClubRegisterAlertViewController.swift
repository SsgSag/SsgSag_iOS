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
    var viewModel: ClubRegisterOneStepViewModel!
    var type: InputType!
    let animationDuration = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearAnim()
    }
    
    func appearAnim() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.backView.transform = CGAffineTransform(translationX: 0, y: -300)
        })
    }
    
    func dismissAnim() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.backView.transform = .identity
        })
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismissAnim()
    }
    
    func isExistSting(arr: [String], text: String) -> Bool {
        var isExist = false
        arr.forEach{
            if $0 == text {
                print("\($0), \(text)")
                isExist = true
                return
            }
        }
        return isExist
    }
}

extension ClubRegisterAlertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == InputType.location ? locations.count : categorys.count
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
        
        if type == InputType.location {
            viewModel.univOrLocationObservable.accept(title)
        } else {
            var tempCategoryArray = viewModel.categoryObservable.value
            
            if !isExistSting(arr: tempCategoryArray, text: title) {
                tempCategoryArray.append(title)
                viewModel.categoryObservable.accept(tempCategoryArray)
            }
        }
        dismissAnim()
    }
}
