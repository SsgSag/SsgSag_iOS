//
//  DetailTodoListTableViewCell.swift
//  SsgSag
//
//  Created by admin on 16/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DetailTodoListTableViewCell: UITableViewCell {
    
    var poster: Posters? {
        didSet {
            guard let posterInfo = poster else {return}
            posterName.text = posterInfo.posterName
            
            guard let category = posterInfo.categoryIdx else {return}
            guard let posterCate = PosterCategory(rawValue: category) else {return}
            
            posterCategory.text = posterCate.categoryString()
            posterCategory.textColor = posterCate.categoryColors()
            
            guard let date = posterInfo.posterEndDate else {return}
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: date)
            let component = Calendar.current.dateComponents([.month, .day, .weekday], from: endDate)
            guard let weekDay = WeekDays(rawValue: component.weekday!) else {return}
            
            guard let startDate = posterInfo.posterStartDate else {return}
            let startDateFormString = DateCaculate.stringToDateWithGenericFormatter(using: startDate)
            let startComponent = Calendar.current.dateComponents([.month, .day, .weekday], from: startDateFormString)
            guard let startWeekDay = WeekDays(rawValue: startComponent.weekday!) else {return}
            
            posterDate.text = "\(startComponent.month!).\(startComponent.day!)(\(startWeekDay.koreanWeekdays))~\(component.month!).\(component.day!)(\(weekDay.koreanWeekdays))"
        }
        
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var posterCategory: UILabel!
    
    @IBOutlet weak var posterDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.posterName.text = ""
    }
    
}
