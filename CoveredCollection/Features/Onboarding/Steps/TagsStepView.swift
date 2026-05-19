import SwiftUI

struct TagsStepView: View {
    @Binding var tags: Set<ModestyTag>

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: CoveredSpacing.md)]

    var body: some View {
        VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
            VStack(alignment: .leading, spacing: CoveredSpacing.sm) {
                Text("Anything else?")
                    .font(.coveredDisplay).foregroundStyle(.coveredInk)
                Text("Pick any that apply. You can change these later.")
                    .font(.coveredBody).foregroundStyle(.coveredMuted)
            }

            LazyVGrid(columns: columns, spacing: CoveredSpacing.md) {
                ForEach(ModestyTag.allCases) { tag in
                    let selected = tags.contains(tag)
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            if selected { tags.remove(tag) } else { tags.insert(tag) }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(selected ? Color.white.opacity(0.18) : Color.coveredTagBg)
                                    .frame(width: 28, height: 28)
                                Image(systemName: tag.symbol)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(selected ? Color.coveredCream : Color.coveredOlive)
                            }
                            Text(tag.displayName)
                                .font(.coveredBody)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                            if selected {
                                Image(systemName: "checkmark")
                                    .font(.caption.weight(.bold))
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(selected ? Color.coveredCream : Color.coveredInk)
                        .background(selected ? Color.coveredOlive : Color.coveredSurface)
                        .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner))
                        .overlay(
                            RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner)
                                .stroke(selected ? Color.coveredOlive : Color.coveredBorder, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, CoveredSpacing.lg)
    }
}
