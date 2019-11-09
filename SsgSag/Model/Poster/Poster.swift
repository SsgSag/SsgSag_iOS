import Foundation

// MARK: - PosterElement
struct Poster: Codable {
    let posterIdx: Int?
    let categoryIdx: Int?
    let subCategoryIdx: Int?
    let photoUrl: String?
    let posterName: String?
    let posterRegDate: String?
    let posterStartDate: String?
    let posterEndDate: String?
    let posterWebSite: String?
    let isSeek: Int?
    let outline: String?
    let target: String?
    let period: String?
    let benefit: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let dday, adminAccept: Int?
    let keyword: String?
    let favoriteNum: Int?
    let likeNum: Int?
}

