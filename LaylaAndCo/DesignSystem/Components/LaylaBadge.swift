import SwiftUI

struct LaylaBadge: View {
    let title: String
    var background: Color = .laylaGold
    var foreground: Color = .laylaInk

    var body: some View {
        Text(title)
            .font(.system(.caption2, design: .default).weight(.semibold))
            .textCase(.uppercase)
            .tracking(1.8)
            .padding(.horizontal, LaylaSpacing.sm)
            .padding(.vertical, 4)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        LaylaBadge(title: "Most Popular")
        LaylaBadge(title: "New", background: .laylaRose, foreground: .laylaCream)
        LaylaBadge(title: "DNA Match", background: .laylaSuccess, foreground: .laylaCream)
    }
    .padding()
    .background(Color.laylaCream)
}
