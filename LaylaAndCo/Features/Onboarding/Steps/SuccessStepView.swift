import SwiftUI

struct SuccessStepView: View {
    let firstName: String
    let dna: ModestyDNA
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: LaylaSpacing.lg) {
            Spacer(minLength: 0)
            ZStack {
                Circle()
                    .fill(Color.laylaTagBg)
                    .frame(width: 140, height: 140)
                Image(systemName: "sparkles")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.laylaOlive)
            }

            VStack(spacing: LaylaSpacing.sm) {
                Text("Welcome, \(firstName).")
                    .font(.laylaDisplay).foregroundStyle(.laylaInk)
                Text("Your Modesty DNA is set. We'll curate your closet around it.")
                    .font(.laylaBody)
                    .foregroundStyle(.laylaMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, LaylaSpacing.xl)
            }

            ModestyDNABadgeRow(dna: dna, compact: false)
                .padding(.horizontal, LaylaSpacing.lg)

            Spacer(minLength: 0)

            LaylaButton(title: "Build My Closet", kind: .primary) {
                onContinue()
            }
            .padding(.horizontal, LaylaSpacing.lg)
        }
        .padding(.vertical, LaylaSpacing.xl)
    }
}
