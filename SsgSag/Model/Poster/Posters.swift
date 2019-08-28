import Foundation

// MARK: - PosterElement
struct Posters: Codable {
    let posterIdx, categoryIdx: Int?
    let subCategoryIdx: Int?
    let photoUrl: String?
    let posterName, posterRegDate, posterStartDate, posterEndDate: String?
    let posterWebSite: String?
    let isSeek: Int?
    let outline, target, period, benefit: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let dday, adminAccept: Int?
    let keyword: String?
    let favoriteNum, likeNum: Int?
}

