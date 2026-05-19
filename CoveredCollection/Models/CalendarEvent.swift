import Foundation

// MARK: - EventCategory

enum EventCategory: String, Hashable, CaseIterable {
    case wedding, eid, graduation, formal, casual
    var symbol: String {
        switch self {
        case .wedding:    return "heart.fill"
        case .eid:        return "moon.stars.fill"
        case .graduation: return "graduationcap.fill"
        case .formal:     return "sparkles"
        case .casual:     return "sun.max.fill"
        }
    }
}

// MARK: - CalendarEvent

struct CalendarEvent: Identifiable {
    let id: UUID
    let name: String
    let date: Date
    let category: EventCategory
    let recommendedEditName: String?

    var daysUntil: Int {
        Calendar.current.dateComponents([.day], from: .now, to: date).day ?? 0
    }
}
