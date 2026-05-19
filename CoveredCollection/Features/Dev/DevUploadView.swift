import SwiftUI

/// Developer-only view for uploading product images.
struct DevUploadView: View {
    @State private var vm = DevUploadViewModel()
    @State private var showImagePicker = false
    @State private var pickImageForSeed: String?

    private let seeds = [
        "sweetsalt-blush-maxi", "zahraa-black-pleated", "verona-tan-suit",
        "inayah-charcoal-abaya", "verona-black-blazer", "aab-camel-trouser",
        "inayah-rose-jersey", "sweetsalt-sage-sweater", "zahraa-mocha-shacket",
        "aab-ivory-crepe", "zahraa-olive-jumpsuit", "mikarose-rust-shirtdress",
        "haute-rose-chiffon", "mikarose-navy-swing", "inayah-emerald-eid",
        "sweetsalt-coral-elbow", "aab-olive-belted", "haute-blackbamboo",
        "dainty-ivory-sheer", "mikarose-floral-prairie", "verona-plum-vneck",
        "dainty-navy-puff", "haute-cream-silk", "dainty-cream-prairie",
    ].sorted()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: CoveredSpacing.lg) {
                    Text("Uploaded: \(vm.uploadedSeeds.count) / \(seeds.count)")
                        .font(.coveredCaption)
                        .foregroundStyle(.coveredMuted)
                        .padding(.horizontal, CoveredSpacing.lg)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: CoveredSpacing.md
                    ) {
                        ForEach(seeds, id: \.self) { seed in
                            seedCard(for: seed)
                        }
                    }
                    .padding(.horizontal, CoveredSpacing.lg)
                    .padding(.bottom, CoveredSpacing.xl)
                }
            }
            .background(Color.coveredCream.ignoresSafeArea())
            .navigationTitle("Dev Upload")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showImagePicker) {
            if let seed = pickImageForSeed {
                ImagePicker { image in
                    vm.pickAndUploadImage(for: seed, image)
                    showImagePicker = false
                }
            }
        }
    }

    @ViewBuilder
    private func seedCard(for seed: String) -> some View {
        VStack(spacing: CoveredSpacing.sm) {
            if let image = vm.imagePreviewMap[seed] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.coveredBorder)
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "photo.badge.plus")
                            .font(.title3)
                            .foregroundStyle(.coveredMuted)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(seed)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.coveredInk)
                    .lineLimit(2)

                HStack(spacing: CoveredSpacing.sm) {
                    Button {
                        pickImageForSeed = seed
                        showImagePicker = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.coveredOlive)

                    if vm.imagePreviewMap[seed] != nil {
                        Button(role: .destructive) {
                            vm.deleteImage(for: seed)
                        } label: {
                            Image(systemName: "trash")
                                .font(.caption)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .font(.caption)
            }
            .padding(CoveredSpacing.sm)
        }
        .background(Color.coveredSurface)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    DevUploadView()
        .environment(UserProfileStore())
}
