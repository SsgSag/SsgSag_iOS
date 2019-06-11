//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    var monthsArr = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var monthDelegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        setupViews()
    }
    
    func leftPanGestureAction() {
        
        currentMonthIndex += 1
        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }
        
        monthName.text="\(currentYear) \(monthsArr[currentMonthIndex])"
        
        monthDelegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func rightPanGestureAction() {
        currentMonthIndex -= 1
        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }
        
        monthName.text="\(currentYear) \(monthsArr[currentMonthIndex])"
        monthDelegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        self.addSubview(monthName)
        
        monthName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        monthName.text="\(currentYear) \(monthsArr[currentMonthIndex])"
    }
    
    //월
    let monthName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font=UIFont.boldSystemFont(ofSize: 25)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


