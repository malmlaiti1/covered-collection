import SwiftUI

struct SuccessStepView: View {
    let firstName: String
    let dna: ModestyDNA
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: CoveredSpacing.lg) {
            Spacer(minLength: 0)
            ZStack {
                Circle()
                    .fill(Color.coveredTagBg)
                    .frame(width: 140, height: 140)
                Image(systemName: "sparkles")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.coveredOlive)
                // Three orbiting dots — gold (top-right), rose (lower-right), olive (lower-left)
                Circle().fill(Color.coveredGold).frame(width: 10, height: 10).offset(x: 60, y: -42)
                Circle().fill(Color.coveredRose).frame(width: 8, height: 8).offset(x: 64, y: 38)
                Circle().fill(Color.coveredOlive).frame(width: 9, height: 9).offset(x: -56, y: 48)
            }

            VStack(spacing: CoveredSpacing.sm) {
                Text("Welcome, \(firstName).")
                    .font(.coveredDisplay).foregroundStyle(.coveredInk)
                Text("Your Modesty DNA is set. We'll curate your closet around it.")
                    .font(.coveredBody)
                    .foregroundStyle(.coveredMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, CoveredSpacing.xl)
            }

            ModestyDNABadgeRow(dna: dna, compact: false)
                .padding(.horizontal, CoveredSpacing.lg)

            Spacer(minLength: 0)

            CoveredButton(title: "Build My Closet", kind: .primary) {
                onContinue()
            }
            .padding(.horizontal, CoveredSpacing.lg)
        }
        .padding(.vertical, CoveredSpacing.xl)
    }
}
