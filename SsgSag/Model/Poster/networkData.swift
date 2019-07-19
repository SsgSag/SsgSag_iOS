import Foundation

struct networkData : Codable {
	let status : Int?
	let message : String?
	let data : posterData?
    
    enum ReadError: Error {
        case JsonError
        
        func printErrorType() {
            switch self {
            case .JsonError:
                print("networkData Json Parsing Error")
            }
        }
        
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(posterData.self, forKey: .data)
	}

}

struct networkPostersData : Codable {
    let status : Int?
    let message : String?
    let data : Posters?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Posters.self, forKey: .data)
    }
    
}
