import Foundation

struct CustomDateFormatter {
    static func getFormattedDate(from string: String?) -> String? {
        guard let string = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: string) else { return nil }
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
