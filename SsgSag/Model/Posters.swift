import Foundation

struct Posters : Codable {
    let posterIdx : Int?
    let categoryIdx : Int?
    let photoUrl : String?
    let posterName : String?
    let posterRegDate : String?
    let posterStartDate : String?
    let posterEndDate : String?
    let posterWebSite : String?
    let outline : String?
    let target : String?
    let period : String?
    let benefit : String?
    let documentDate : String?
    let contentIdx : Int?
    let hostIdx : Int?
    let posterDetail : String?
    let posterInterest : [Int]?
    let dday : Int?
    let keyword: String?
    
    enum CodingKeys: String, CodingKey {
        
        case posterIdx = "posterIdx"
        case categoryIdx = "categoryIdx"
        case photoUrl = "photoUrl"
        case posterName = "posterName"
        case keyword = "keyword"
        case posterRegDate = "posterRegDate"
        case posterStartDate = "posterStartDate"
        case posterEndDate = "posterEndDate"
        case posterWebSite = "posterWebSite"
        case outline = "outline"
        case target = "target"
        case period = "period"
        case benefit = "benefit"
        case documentDate = "documentDate"
        case contentIdx = "contentIdx"
        case hostIdx = "hostIdx"
        case posterDetail = "posterDetail"
        case posterInterest = "posterInterest"
        case dday = "dday"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        posterIdx = try values.decodeIfPresent(Int.self, forKey: .posterIdx)
        categoryIdx = try values.decodeIfPresent(Int.self, forKey: .categoryIdx)
        photoUrl = try values.decodeIfPresent(String.self, forKey: .photoUrl)
        posterName = try values.decodeIfPresent(String.self, forKey: .posterName)
        keyword = try values.decodeIfPresent(String.self, forKey: .keyword)
        posterRegDate = try values.decodeIfPresent(String.self, forKey: .posterRegDate)
        posterStartDate = try values.decodeIfPresent(String.self, forKey: .posterStartDate)
        posterEndDate = try values.decodeIfPresent(String.self, forKey: .posterEndDate)
        posterWebSite = try values.decodeIfPresent(String.self, forKey: .posterWebSite)
        outline = try values.decodeIfPresent(String.self, forKey: .outline)
        target = try values.decodeIfPresent(String.self, forKey: .target)
        period = try values.decodeIfPresent(String.self, forKey: .period)
        benefit = try values.decodeIfPresent(String.self, forKey: .benefit)
        documentDate = try values.decodeIfPresent(String.self, forKey: .documentDate)
        contentIdx = try values.decodeIfPresent(Int.self, forKey: .contentIdx)
        hostIdx = try values.decodeIfPresent(Int.self, forKey: .hostIdx)
        posterDetail = try values.decodeIfPresent(String.self, forKey: .posterDetail)
        posterInterest = try values.decodeIfPresent([Int].self, forKey: .posterInterest)
        dday = try values.decodeIfPresent(Int.self, forKey: .dday)
    }
    
}
