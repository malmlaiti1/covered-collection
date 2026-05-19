import SwiftUI

extension Font {
    static let coveredDisplay   = Font.system(.largeTitle, design: .serif).weight(.regular)
    static let coveredHeadline  = Font.system(.title, design: .serif).weight(.regular)
    static let coveredTitle     = Font.system(.title3, design: .serif).weight(.medium)
    static let coveredBody      = Font.system(.body, design: .default)
    static let coveredBodyEmph  = Font.system(.body, design: .default).weight(.semibold)
    static let coveredCaption   = Font.system(.caption, design: .default)
    static let coveredSmallCaps    = Font.system(.caption, design: .default).weight(.medium)
    static let coveredProductName  = Font.system(.subheadline, design: .serif)
}

extension View {
    func coveredSmallCaps() -> some View {
        self
            .font(.coveredSmallCaps)
            .textCase(.uppercase)
            .tracking(1.6)
    }
}
