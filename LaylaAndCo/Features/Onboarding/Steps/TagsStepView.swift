import SwiftUI

struct TagsStepView: View {
    @Binding var tags: Set<ModestyTag>

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: LaylaSpacing.md)]

    var body: some View {
        VStack(alignment: .leading, spacing: LaylaSpacing.lg) {
            VStack(alignment: .leading, spacing: LaylaSpacing.sm) {
                Text("Anything else?")
                    .font(.laylaDisplay).foregroundStyle(.laylaInk)
                Text("Pick any that apply. You can change these later.")
                    .font(.laylaBody).foregroundStyle(.laylaMuted)
            }

            LazyVGrid(columns: columns, spacing: LaylaSpacing.md) {
                ForEach(ModestyTag.allCases) { tag in
                    let selected = tags.contains(tag)
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            if selected { tags.remove(tag) } else { tags.insert(tag) }
                        }
                    } label: {
                        HStack {
                            Image(systemName: tag.symbol)
                            Text(tag.displayName)
                                .font(.laylaBody)
                            Spacer()
                            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                        }
                        .padding(LaylaSpacing.md)
                        .foregroundStyle(selected ? Color.laylaCream : Color.laylaInk)
                        .background(selected ? Color.laylaOlive : Color.laylaSurface)
                        .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner))
                        .overlay(
                            RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner)
                                .stroke(Color.laylaBorder, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, LaylaSpacing.lg)
    }
}
