import Foundation

struct networkData : Codable {
	let status : Int?
	let message : String?
	let data : posterData?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case data = "data"
	}
    
    enum ReadError: Error {
        case JsonError
        
        func printErrorType() {
            switch self {
            case .JsonError:
                print("networkData Json Parsing Error")
            default:
                break
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
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Posters.self, forKey: .data)
    }
    
}
