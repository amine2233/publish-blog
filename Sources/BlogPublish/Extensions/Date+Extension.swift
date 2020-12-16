import Foundation

extension Date {
    var asText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
