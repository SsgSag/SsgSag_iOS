extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension DateFormatter {
    
    static let genericDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let basicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let basicDateFormatterWithKorea: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    static let dateFormatterWithKoreanDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 EEE"
        return formatter
    }()
    
    static let feedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    static let commentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 h:m"
        return formatter
    }()
}
