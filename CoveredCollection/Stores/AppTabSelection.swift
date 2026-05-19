import Foundation
import Observation

enum AppTab: Hashable {
    case closet, calendar, myBox, saved, account
    #if DEBUG
    case devUpload
    #endif
}

@Observable
final class AppTabSelection {
    var selected: AppTab = .closet
}
