//
//  UnivCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SearchTextField

class UnivCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var univTextField: SearchTextField!
    @IBOutlet weak var majorTextField: SearchTextField!
    
    var jsonResult: [[String: Any]] = [[:]]
    var univName: String? {
        didSet {
            guard let univName = self.univName else {
                return
            }
            
            univTextField.text = univName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSimpleSearchTextField()
        configureSimpleMajorSearchTextField()
    }
    
    private func configureSimpleSearchTextField() {
        univTextField.startVisible = true
        
        let universities = localUniversities()
        univTextField.filterStrings(universities)
    }
    
    private func configureSimpleMajorSearchTextField() {
        majorTextField.startVisible = true
        
        let majors = localMajors()
        majorTextField.filterStrings(majors)
    }
    
    private func localUniversities() -> [String] {
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
            
            self.jsonResult = jsonResult
            
            var resultUnivNames: [String] = []
            
            jsonResult.forEach {
                let univName = "\($0["학교명"]!)"
                if !resultUnivNames.contains(univName) {
                    resultUnivNames.append(univName)
                }
            }
            
            return resultUnivNames
        } catch {
            print("Error parsing jSON: \(error)")
            return []
        }
    }
    
    private func localMajors() -> [String] {
        let univName = univTextField.text
        
        for university in jsonResult {
            if univName == "\(university["학교명"]!)" {
                guard let majors = university["학부·과(전공)명"] as? [String] else {
                    return []
                }
                
                return majors
            }
        }
        
        return []
    }
    
    @IBAction func editingDidBeginMajorTextField(_ sender: Any) {
        configureSimpleMajorSearchTextField()
    }
    
}
