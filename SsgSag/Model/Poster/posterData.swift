import Foundation

struct posterData : Codable {
	let posters : [Posters]?
	let userCnt : Int?
    
	enum CodingKeys: String, CodingKey {
		case posters = "posters"
		case userCnt = "userCnt"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		posters = try values.decodeIfPresent([Posters].self, forKey: .posters)
		userCnt = try values.decodeIfPresent(Int.self, forKey: .userCnt)
	}
    
    
}
