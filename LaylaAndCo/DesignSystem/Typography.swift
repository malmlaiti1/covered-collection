import SwiftUI

extension Font {
    static let laylaDisplay   = Font.system(.largeTitle, design: .serif).weight(.regular)
    static let laylaHeadline  = Font.system(.title, design: .serif).weight(.regular)
    static let laylaTitle     = Font.system(.title3, design: .serif).weight(.medium)
    static let laylaBody      = Font.system(.body, design: .default)
    static let laylaBodyEmph  = Font.system(.body, design: .default).weight(.semibold)
    static let laylaCaption   = Font.system(.caption, design: .default)
    static let laylaSmallCaps = Font.system(.caption, design: .default).weight(.medium)
}

extension View {
    func laylaSmallCaps() -> some View {
        self
            .font(.laylaSmallCaps)
            .textCase(.uppercase)
            .tracking(1.6)
    }
}
