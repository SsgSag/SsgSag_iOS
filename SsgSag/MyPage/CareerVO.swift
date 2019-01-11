//
//  CareerVO.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 11..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import Foundation

struct CareerVO : Codable {
    let careerIdx : Int?
    let userIdx : Int?
    let careerType : Int?
    let careerName : String?
    let careerContent : String?
    let careerDate1 : String?
    let careerDate2 : String?
    let careerRegDate : String?
    
    enum CodingKeys: String, CodingKey {
        
        case careerIdx = "careerIdx"
        case userIdx = "userIdx"
        case careerType = "careerType"
        case careerName = "careerName"
        case careerContent = "careerContent"
        case careerDate1 = "careerDate1"
        case careerDate2 = "careerDate2"
        case careerRegDate = "careerRegDate"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        careerIdx = try values.decodeIfPresent(Int.self, forKey: .careerIdx)
        userIdx = try values.decodeIfPresent(Int.self, forKey: .userIdx)
        careerType = try values.decodeIfPresent(Int.self, forKey: .careerType)
        careerName = try values.decodeIfPresent(String.self, forKey: .careerName)
        careerContent = try values.decodeIfPresent(String.self, forKey: .careerContent)
        careerDate1 = try values.decodeIfPresent(String.self, forKey: .careerDate1)
        careerDate2 = try values.decodeIfPresent(String.self, forKey: .careerDate2)
        careerRegDate = try values.decodeIfPresent(String.self, forKey: .careerRegDate)
    }
    
    
}

