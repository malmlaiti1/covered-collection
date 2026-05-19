import SwiftUI

enum CoveredButtonKind {
    case primary
    case secondary
    case textLink
}

struct CoveredButton: View {
    let title: String
    var kind: CoveredButtonKind = .primary
    var systemImage: String? = nil
    var isFullWidth: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: CoveredSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.coveredBodyEmph)
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil, minHeight: 48)
            .padding(.horizontal, CoveredSpacing.lg)
            .foregroundStyle(foreground)
            .background(background)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous))
        }
        .accessibilityLabel(Text(title))
    }

    private var foreground: Color {
        switch kind {
        case .primary:   return .coveredCream
        case .secondary: return .coveredOlive
        case .textLink:  return .coveredOlive
        }
    }

    private var background: some View {
        Group {
            switch kind {
            case .primary:   Color.coveredOlive
            case .secondary: Color.clear
            case .textLink:  Color.clear
            }
        }
    }

    @ViewBuilder
    private var border: some View {
        switch kind {
        case .secondary:
            RoundedRectangle(cornerRadius: CoveredSpacing.cardCorner, style: .continuous)
                .stroke(Color.coveredOlive, lineWidth: 1)
        default:
            EmptyView()
        }
    }
}

#Preview {
    VStack(spacing: CoveredSpacing.md) {
        CoveredButton(title: "Build My Closet", kind: .primary) {}
        CoveredButton(title: "Reserve for an Event", kind: .secondary) {}
        CoveredButton(title: "Buy this instead — $148", kind: .textLink) {}
    }
    .padding()
    .background(Color.coveredCream)
}
