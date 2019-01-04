/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

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
	let isSeek : Int?
	let outline : String?
	let target : String?
	let period : String?
	let benefit : String?
	let announceDate1 : String?
	let announceDate2 : String?
	let finalAnnounceDate : String?
	let interviewDate : String?
	let documentDate : String?

	enum CodingKeys: String, CodingKey {

		case posterIdx = "posterIdx"
		case categoryIdx = "categoryIdx"
		case photoUrl = "photoUrl"
		case posterName = "posterName"
		case posterRegDate = "posterRegDate"
		case posterStartDate = "posterStartDate"
		case posterEndDate = "posterEndDate"
		case posterWebSite = "posterWebSite"
		case isSeek = "isSeek"
		case outline = "outline"
		case target = "target"
		case period = "period"
		case benefit = "benefit"
		case announceDate1 = "announceDate1"
		case announceDate2 = "announceDate2"
		case finalAnnounceDate = "finalAnnounceDate"
		case interviewDate = "interviewDate"
		case documentDate = "documentDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		posterIdx = try values.decodeIfPresent(Int.self, forKey: .posterIdx)
		categoryIdx = try values.decodeIfPresent(Int.self, forKey: .categoryIdx)
		photoUrl = try values.decodeIfPresent(String.self, forKey: .photoUrl)
		posterName = try values.decodeIfPresent(String.self, forKey: .posterName)
		posterRegDate = try values.decodeIfPresent(String.self, forKey: .posterRegDate)
		posterStartDate = try values.decodeIfPresent(String.self, forKey: .posterStartDate)
		posterEndDate = try values.decodeIfPresent(String.self, forKey: .posterEndDate)
		posterWebSite = try values.decodeIfPresent(String.self, forKey: .posterWebSite)
		isSeek = try values.decodeIfPresent(Int.self, forKey: .isSeek)
		outline = try values.decodeIfPresent(String.self, forKey: .outline)
		target = try values.decodeIfPresent(String.self, forKey: .target)
		period = try values.decodeIfPresent(String.self, forKey: .period)
		benefit = try values.decodeIfPresent(String.self, forKey: .benefit)
		announceDate1 = try values.decodeIfPresent(String.self, forKey: .announceDate1)
		announceDate2 = try values.decodeIfPresent(String.self, forKey: .announceDate2)
		finalAnnounceDate = try values.decodeIfPresent(String.self, forKey: .finalAnnounceDate)
		interviewDate = try values.decodeIfPresent(String.self, forKey: .interviewDate)
		documentDate = try values.decodeIfPresent(String.self, forKey: .documentDate)
	}

}