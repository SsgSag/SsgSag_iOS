//
//  AnalysticsCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AnalysticsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var majorChartView: PieChartView!
    
    @IBOutlet weak var gradeChartView: PieChartView!
    
    @IBOutlet weak var genderChartView: PieChartView!
    
    @IBOutlet weak var interestedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        majorChartView.layer.sublayers?.forEach {
            if let _ = $0 as? CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
        
        gradeChartView.layer.sublayers?.forEach {
            if let _ = $0 as? CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
        
        genderChartView.layer.sublayers?.forEach {
            if let _ = $0 as? CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func configure(analyticsData: Analytics?) {
        setupInterestedLabel(major: analyticsData?.majorCategory?[0],
                             grade: analyticsData?.grade?[0],
                             gender: analyticsData?.gender?[0])
        
        guard let majorCategorys = analyticsData?.majorCategory,
            let majorRates = analyticsData?.majorCategoryRate else {
            return
        }

        majorChartView.configureAnalyticsWith(strings: majorCategorys,
                                              rates: majorRates)
        
        
        guard let gradeCategorys = analyticsData?.grade,
            let gradeRates = analyticsData?.gradeRate else {
                return
        }
        
        gradeChartView.configureAnalyticsWith(strings: gradeCategorys,
                                              rates: gradeRates)

        guard let genderCategorys = analyticsData?.gender,
            let genderRates = analyticsData?.genderRate else {
                return
        }
        
        genderChartView.configureAnalyticsWith(strings: genderCategorys,
                                               rates: genderRates)
    }
    
    private func setupInterestedLabel(major: String?, grade: String?, gender: String?) {
        guard let major = major,
            let grade = grade,
            let gender = gender else {
            return
        }
        
        interestedLabel.text = "\(major) \(grade) \(gender)가 관심이 많아요"
    }

}
