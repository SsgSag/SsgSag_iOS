import Foundation

struct CalendarForNetwork: Codable {
    let status: Int?
    let message: String?
    let data: [CalendarForDefault]?
}

struct CalendarForDefault: Codable {
    let categoryIdx, isCompleted, isEnded: Int?
    let posterEndDate: String?
}
