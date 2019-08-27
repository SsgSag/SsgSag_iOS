//
//  NonActivityCell.swift
//  SsgSag
//
//  Created by CHOMINJI on 31/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NonActivityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel1: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    weak var activityDelegate: activityDelegate?
    
    private let activityServiceImp: ActivityService
        = DependencyContainer.shared.getDependency(key: .activityService)
    
    var careerInfo: careerData? {
        didSet {
            guard let career = self.careerInfo else {return}
            
            titleLabel.text = career.careerName
            dateLabel1.text = career.careerDate1
            detailLabel.text = career.careerContent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func touchUpDeleteButton(_ sender: UIButton) {
        guard let careerIdx = self.careerInfo?.careerIdx else {return}
        
        activityServiceImp.requestDeleteActivity(contentIdx: careerIdx) { (dataResponse) in
            guard let status = dataResponse.value?.status else {return}
            
            guard let httpStatusCode = HttpStatusCode(rawValue: status) else {return}
            
            switch httpStatusCode {
            case .processingSuccess:
                self.activityDelegate?.deleteSuccess()
            case .dataBaseError, .serverError:
                print("데이터베이스 에러")
            default:
                print("데이터베이스 에러 Status 코드 다른")
            }
        }
    }
}
