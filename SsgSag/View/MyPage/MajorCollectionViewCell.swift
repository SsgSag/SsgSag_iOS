//
//  MajorCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SearchTextField

class MajorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var majorTextField: SearchTextField!
    
    var univName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSimpleMajorSearchTextField()
    }
    
    private func configureSimpleMajorSearchTextField() {
        majorTextField.startVisible = true
        
        let majors = localMajors()
        majorTextField.filterStrings(majors)
    }

    private func localMajors() -> [String] {
        guard let path = Bundle.main.path(forResource: "majorListByUniv",
                                          ofType: "json") else {
                                            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .dataReadingMapped)
            
            guard let jsonResult
                = try JSONSerialization.jsonObject(with: jsonData,
                                                   options: .allowFragments)
                    as? [[String: Any]] else {
                        return []
            }
            
            for university in jsonResult {
                if univName == "\(university["학교명"]!)" {
                    guard let majors = university["학부·과(전공)명"] as? [String] else {
                        return []
                    }
                    
                    return majors
                }
            }
        } catch {
            print("Error parsing jSON: \(error)")
            return []
        }
        
        return []
    }
    
}
