import SwiftUI
import Observation

enum AppTab: Int, Hashable {
    case closet = 0
    case calendar
    case myBox
    case saved
    case account
}

@MainActor
@Observable
final class AppTabSelection {
    var selected: AppTab = .closet
}
