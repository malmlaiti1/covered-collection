import SwiftUI

enum LaylaButtonKind {
    case primary
    case secondary
    case textLink
}

struct LaylaButton: View {
    let title: String
    var kind: LaylaButtonKind = .primary
    var systemImage: String? = nil
    var isFullWidth: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: LaylaSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.laylaBodyEmph)
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil, minHeight: 48)
            .padding(.horizontal, LaylaSpacing.lg)
            .foregroundStyle(foreground)
            .background(background)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous))
        }
        .accessibilityLabel(Text(title))
    }

    private var foreground: Color {
        switch kind {
        case .primary:   return .laylaCream
        case .secondary: return .laylaOlive
        case .textLink:  return .laylaOlive
        }
    }

    private var background: some View {
        Group {
            switch kind {
            case .primary:   Color.laylaOlive
            case .secondary: Color.clear
            case .textLink:  Color.clear
            }
        }
    }

    @ViewBuilder
    private var border: some View {
        switch kind {
        case .secondary:
            RoundedRectangle(cornerRadius: LaylaSpacing.cardCorner, style: .continuous)
                .stroke(Color.laylaOlive, lineWidth: 1)
        default:
            EmptyView()
        }
    }
}

#Preview {
    VStack(spacing: LaylaSpacing.md) {
        LaylaButton(title: "Build My Closet", kind: .primary) {}
        LaylaButton(title: "Reserve for an Event", kind: .secondary) {}
        LaylaButton(title: "Buy this instead — $148", kind: .textLink) {}
    }
    .padding()
    .background(Color.laylaCream)
}
