import Foundation

struct Career: Codable {
    let status: Int
    let message: String
    let data: [careerData]
}

struct careerData: Codable {
    let careerIdx, userIdx, careerType: Int
    let careerName, careerContent, careerDate1: String
    let careerRegDate: String
    let careerDate2: String?
}

