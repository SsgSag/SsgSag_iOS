//
//  ClubActInfoAlertViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ClubActInfoAlertViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    let locations = ClubAbout.locations
    var clubactInfo: ClubActInfoModel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewBotLayout: NSLayoutConstraint!
    let feedbackGenerator = UISelectionFeedbackGenerator()
    let animationDuration = 0.3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearAnim(type: clubactInfo.inputType)
    }
    
    func setupDatePicker() {
        let curDate = Date()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: curDate)
        datePicker.maximumDate = curDate
    }
    
    func appearAnim(type: InputType) {
        if type == .location {
            self.locationView.isHidden = false
           UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.locationView.transform = CGAffineTransform(translationX: 0, y: -300)
            })
        } else {
            self.dateView.isHidden = false
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.dateView.transform = CGAffineTransform(translationX: 0, y: -300)
            })
        }
        self.view.layoutIfNeeded()
    }
    
    func dismissAnim(type: InputType) {
        if type == .location {
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.locationView.transform = .identity
            })
        } else {
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.dateView.transform = .identity
            })
        }
        
        self.view.layoutIfNeeded()
        self.dismiss(animated: true)
    }
    
    func dateCompare(model: ClubActInfoModel) -> Bool {

        guard let startSaveDate = model.startSaveDate else {return true}
        guard let endSaveDate = model.endSaveDate else {return true}
        
        let startDay = Calendar.current.dateComponents([.year, .month, .day], from: startSaveDate)
        let endDay = Calendar.current.dateComponents([.year, .month, .day], from: endSaveDate)
        
        let sYear = startDay.year!
        let sMonth = startDay.month!
        let sDay = startDay.day!
        
        let eYear = endDay.year!
        let eMonth = endDay.month!
        let eDay = endDay.day!
        
        if sYear > eYear {
            return false
        } else if sYear == eYear {
            if sMonth > eMonth {
                return false
            } else if sMonth == eMonth {
                if sDay > eDay {
                    return false
                }
            }
        }
        
        return true
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismissAnim(type: clubactInfo.inputType)
    }
    
    @IBAction func dateConfirmClick(_ sender: Any) {
        
        let dateShowString = DateCaculate.dateToStringShowDateFormatter(date: datePicker.date)
        let dateRequestString = DateCaculate.dateToStringRequestDateDateFormatter(date: datePicker.date)
        
        if clubactInfo.inputType == .start {
            clubactInfo.startSaveDate = datePicker.date
            if dateCompare(model: clubactInfo) {
                clubactInfo.startDate.accept(dateShowString)
                clubactInfo.startRequestDate = dateRequestString
            } else {
                self.simpleAlert(title: "다시 한번 확인해주세요.", message: "활동시작 날짜가 종료날짜보다 빠를 수 없어요.")
                return
            }
        } else {
            clubactInfo.endSaveDate = datePicker.date
            if dateCompare(model: clubactInfo) {
                clubactInfo.endDate.accept(dateShowString)
                clubactInfo.endRequestDate = dateRequestString
            } else {
                self.simpleAlert(title: "다시 한번 확인해주세요.", message: "활동시작 날짜가 종료날짜보다 빠를 수 없어요.")
                return
            }
        }
        
        dismissAnim(type: clubactInfo.inputType)
    }
    
    @IBAction func dateChage(_ sender: Any) {
        feedbackGenerator.selectionChanged()
    }
}

extension ClubActInfoAlertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActLocationCell", for: indexPath) as! ActLocationTableViewCell
        cell.locationLabel.text = self.locations[safe: indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActLocationTableViewCell
        guard let location = cell.locationLabel.text else {return}
        clubactInfo.location.accept(location)
        dismissAnim(type: clubactInfo.inputType)
    }
}


