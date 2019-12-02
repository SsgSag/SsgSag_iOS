import Foundation

// MARK: - PosterElement
struct Posters: Codable {
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
    
    init(posterIdx: Int? = nil,
         categoryIdx: Int? = nil,
         subCategoryIdx: Int? = nil,
         photoUrl: String? = nil,
         posterName: String? = nil,
         posterRegDate: String? = nil,
         posterStartDate: String? = nil,
         posterEndDate: String? = nil,
         posterWebSite: String? = nil,
         isSeek: Int? = nil,
         outline: String? = nil,
         target: String? = nil,
         period: String? = nil,
         benefit: String? = nil,
         documentDate: String? = nil,
         contentIdx: Int? = nil,
         hostIdx: Int? = nil,
         posterDetail: String? = nil,
         posterInterest: [Int]? = nil,
         dday: Int? = nil,
         adminAccept: Int? = nil,
         keyword: String? = nil,
         favoriteNum: Int? = nil,
         likeNum: Int? = nil) {
        
        self.posterIdx = posterIdx
        self.categoryIdx = categoryIdx
        self.subCategoryIdx = subCategoryIdx
        self.photoUrl = photoUrl
        self.posterName = posterName
        self.posterRegDate = posterRegDate
        self.posterStartDate = posterStartDate
        self.posterEndDate = posterEndDate
        self.posterWebSite = posterWebSite
        self.isSeek = isSeek
        self.outline = outline
        self.target = target
        self.period = period
        self.benefit = benefit
        self.documentDate = documentDate
        self.contentIdx = contentIdx
        self.hostIdx = hostIdx
        self.posterDetail = posterDetail
        self.posterInterest = posterInterest
        self.dday = dday
        self.adminAccept = adminAccept
        self.keyword = keyword
        self.favoriteNum = favoriteNum
        self.likeNum = likeNum
    }
}

