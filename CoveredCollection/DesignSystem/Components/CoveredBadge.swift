import SwiftUI

struct CoveredBadge: View {
    let title: String
    var background: Color = .coveredGold
    var foreground: Color = .coveredInk

    var body: some View {
        Text(title)
            .font(.system(.caption2, design: .default).weight(.semibold))
            .textCase(.uppercase)
            .tracking(1.8)
            .padding(.horizontal, CoveredSpacing.sm)
            .padding(.vertical, 4)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        CoveredBadge(title: "Most Popular")
        CoveredBadge(title: "New", background: .coveredRose, foreground: .coveredCream)
        CoveredBadge(title: "DNA Match", background: .coveredSuccess, foreground: .coveredCream)
    }
    .padding()
    .background(Color.coveredCream)
}
