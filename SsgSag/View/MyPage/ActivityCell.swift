//
//  ActivityCell.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel1: UILabel!
    
    @IBOutlet weak var dateLabel2: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    private var activityServiceImp: ActivityService? = ActivityServiceImp()
    
    var activityInfo: careerData? {
        didSet {
            guard let activity = activityInfo else {return}
            
            titleLabel.text = activity.careerName
            dateLabel1.text = activity.careerDate1
            
            guard let carrerDate2 = activity.careerDate2 else { return }
            
            dateLabel2.text = "~ " + carrerDate2
            detailLabel.text = activity.careerContent
        }
    }
    
    var activityDelegate: activityDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteActivity(_ sender: Any) {
        
        guard let activityInfo = self.activityInfo else {return}
        
        activityServiceImp?.requestDeleteActivity(contentIdx: activityInfo.careerIdx) { (dataResponse) in
            guard let status = dataResponse.value?.status else {return}
            
            guard let httpStatusCode = HttpStatusCode(rawValue: status) else {return}
            
            switch httpStatusCode {
            case .favoriteSuccess:
                self.activityDelegate?.deleteSuccess()
            case .dataBaseError, .serverError:
                print("데이터베이스 에러")
            default:
                print("데이터베이스 에러 Status 코드 다른")
            }
        }
    }
    
}

protocol activityDelegate: class {
    func deleteSuccess()
}


