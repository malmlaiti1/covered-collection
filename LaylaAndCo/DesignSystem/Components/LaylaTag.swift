import SwiftUI

struct LaylaTag: View {
    let title: String
    var systemImage: String? = nil
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: LaylaSpacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption)
            }
            Text(title)
                .font(.laylaCaption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, LaylaSpacing.md)
        .padding(.vertical, LaylaSpacing.sm)
        .foregroundStyle(isSelected ? Color.laylaCream : Color.laylaInk)
        .background(isSelected ? Color.laylaOlive : Color.laylaTagBg)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(isSelected ? Color.laylaOlive : Color.laylaBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HStack {
        LaylaTag(title: "All", isSelected: true)
        LaylaTag(title: "Workwear", systemImage: "briefcase")
        LaylaTag(title: "Eid Ready", systemImage: "sparkles")
    }
    .padding()
    .background(Color.laylaCream)
}
