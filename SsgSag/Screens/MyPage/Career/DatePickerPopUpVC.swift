//
//  DatePickerPopUpVC.swift
//  Alamofire
//
//  Created by CHOMINJI on 2019. 1. 6..
//

import UIKit

class DatePickerPopUpVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var defaultDate: String = ""
    
    var dateString: String = ""
    var buttonTag: Int = 0
    var startDateString: String = ""
    var endDateString: String = ""
    var activityCategory: ActivityCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.makeRounded(cornerRadius: 5)
        
        setDatePickerStartDate()
    }
    
    private func setDatePickerStartDate() {
        datePicker.date = DateCaculate.stringToDateWithBasicFormatterWithKorea(using: defaultDate)
    }
    
    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {
        
        dateString = self.dateFormatter.string(from: datePicker.date)
        
        if let startDate: Date = self.dateFormatter.date(from: startDateString) {
            isStartDateBeforeEndDate(startDate: startDate, endDate: datePicker.date)
            isEndDateAfterStartDate(startDate: startDate, endDate: datePicker.date)
        }
        
        if let endDate: Date = self.dateFormatter.date(from: endDateString) {
            isStartDateBeforeEndDate(startDate: datePicker.date, endDate: endDate)
            isEndDateAfterStartDate(startDate: datePicker.date, endDate: endDate)
        }
        
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func touchUpOkButton(_ sender: UIButton) {
        
        guard let activityCategory = activityCategory else {
            return
        }
        
        switch activityCategory {
            
        case .AddActivityVC:
            
            let previousVC = self.parent as! AddActivityVC
            
            if buttonTag == 0 {
                previousVC.startDateLabel.text = dateString
            } else {
                previousVC.endDateLabel.text = dateString
            }
            
        case .AddVC:
            
            let previousVC = self.parent as! AddVC

            previousVC.dateButton.setTitle(dateString, for: .normal)
            
        case .AddCertificationVC:
            
            let previousVC = self.parent as! AddCertificationVC
            
            previousVC.dateButton.setTitle(dateString, for: .normal)
            
        }
        
        self.view.removeFromSuperview()
    }
    
    func isStartDateBeforeEndDate(startDate: Date, endDate: Date) {
        if startDate > endDate {
            datePicker.minimumDate = startDate
        }
    }
    
    func isEndDateAfterStartDate(startDate: Date, endDate: Date) {
        if endDate < startDate {
            datePicker.maximumDate = endDate
        }
        
        print(startDate)
        print(endDate)
    }
}
