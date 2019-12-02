import Foundation

struct PosterData : Codable {
	let posters : [Posters]?
	let userCnt : Int?
    
    init(_ posters: [Posters]? = nil, _ userCnt: Int? = nil) {
        self.posters = posters
        self.userCnt = userCnt
    }
}
