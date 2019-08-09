//
//  DetailTodoListTableViewCell.swift
//  SsgSag
//
//  Created by admin on 16/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DetailTodoListTableViewCell: UITableViewCell {
    
    var poster: MonthTodoData? {
        didSet {
            guard let posterInfo = poster else {return}
            posterName.text = posterInfo.posterName
            
            guard let categoryIdx = posterInfo.categoryIdx,
                let posterCate = PosterCategory(rawValue: categoryIdx),
                let posterEndDate = posterInfo.posterEndDate else { return }
            
            categoryButton.setTitle(posterCate.categoryString(), for: .normal)
            categoryButton.setTitleColor(posterCate.categoryColors(), for: .normal)
            
            categoryButton.backgroundColor = posterCate.categoryColors().withAlphaComponent(0.05)
            
            let endDate = DateCaculate.stringToDateWithGenericFormatter(using: posterEndDate)
            let component = Calendar.current.dateComponents([.month, .day, .weekday], from: endDate)
            guard let weekDay = WeekDays(rawValue: component.weekday!) else {return}
            
            let startDateFormString = DateCaculate.stringToDateWithGenericFormatter(using: posterInfo.posterStartDate ?? "")
            let startComponent = Calendar.current.dateComponents([.month, .day, .weekday], from: startDateFormString)
            guard let startWeekDay = WeekDays(rawValue: startComponent.weekday!) else {return}
            
            posterDate.text = "\(startComponent.month!).\(startComponent.day!)(\(startWeekDay.koreanWeekdays))~\(component.month!).\(component.day!)(\(weekDay.koreanWeekdays))"
        }
        
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    
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
    
    @IBAction func touchUpFavoriteButton(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "ic_favorite") {
            sender.setImage(UIImage(named: "ic_favoritePassive"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_favorite"), for: .normal)
        }
    }
}
