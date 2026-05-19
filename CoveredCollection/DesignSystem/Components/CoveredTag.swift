import SwiftUI

struct CoveredTag: View {
    let title: String
    var systemImage: String? = nil
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: CoveredSpacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption)
            }
            Text(title)
                .font(.coveredCaption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, CoveredSpacing.md)
        .padding(.vertical, CoveredSpacing.sm)
        .foregroundStyle(isSelected ? Color.coveredCream : Color.coveredInk)
        .background(isSelected ? Color.coveredOlive : Color.coveredTagBg)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(isSelected ? Color.coveredOlive : Color.coveredBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HStack {
        CoveredTag(title: "All", isSelected: true)
        CoveredTag(title: "Workwear", systemImage: "briefcase")
        CoveredTag(title: "Eid Ready", systemImage: "sparkles")
    }
    .padding()
    .background(Color.coveredCream)
}
