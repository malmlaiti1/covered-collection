import Foundation

enum EventCategory: String, Codable, CaseIterable, Hashable {
    case religious, personal, seasonal
    var symbol: String {
        switch self {
        case .religious: return "moon.stars"
        case .personal:  return "heart"
        case .seasonal:  return "leaf"
        }
    }
}

struct CalendarEvent: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let date: Date
    let category: EventCategory
    let recommendedEditName: String?

    var daysUntil: Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = cal.startOfDay(for: date)
        return cal.dateComponents([.day], from: start, to: end).day ?? 0
    }
}
