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
    var dateString: String = ""
    var buttonTag: Int = 0
    var startDateString: String = ""
    var endDateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("한번호출")
        backView.makeRounded(cornerRadius: 5)
        
        if let startDate: Date = self.dateFormatter.date(from: startDateString) {
            datePicker.minimumDate = startDate
        }
        
        //FIXME: - endDate보다 시작날짜
        print(endDateString)
        if let endDate: Date = self.dateFormatter.date(from: endDateString) {
            datePicker.maximumDate = endDate
        }
        
        
    }
    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {
        let date: Date = self.datePicker.date
        dateString = self.dateFormatter.string(from: date)
        if let startDate: Date = self.dateFormatter.date(from: startDateString) {
            isStartDateBeforeEndDate(startDate: startDate, endDate: date)
            isEndDateAfterStartDate(startDate: startDate, endDate: date)
        }
        if let endDate: Date = self.dateFormatter.date(from: endDateString) {
            isStartDateBeforeEndDate(startDate: date, endDate: endDate)
            isEndDateAfterStartDate(startDate: date, endDate: endDate)
        }
        
    }
    
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func touchUpOkButton(_ sender: UIButton) {
        print(buttonTag)
        let previousVC = self.parent as! AddActivityVC
        if buttonTag == 0 {
            previousVC.startDateLabel.text = dateString
        } else {
            previousVC.endDateLabel.text = dateString
            print("끝날짜 \(dateString)")
        }
        print("끝날짜 선택")
        self.view.removeFromSuperview()
    }
    
    func isStartDateBeforeEndDate(startDate: Date, endDate: Date) {
        if startDate > endDate {
            print("dkdk")
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
