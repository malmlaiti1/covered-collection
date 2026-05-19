import UIKit

/// Manages state for the dev upload feature.
@Observable
final class DevUploadViewModel {
    var uploadedSeeds: [String] = []
    var imagePreviewMap: [String: UIImage] = [:]

    init() {
        load()
    }

    /// Load all currently uploaded images
    func load() {
        let seeds = DevModeStore.shared.getAllUploadedSeeds()
        uploadedSeeds = seeds.sorted()

        imagePreviewMap.removeAll()
        for seed in seeds {
            if let image = DevModeStore.shared.loadUploadedImage(for: seed) {
                imagePreviewMap[seed] = image
            }
        }
    }

    /// Save image for a specific seed
    func pickAndUploadImage(for seed: String, _ image: UIImage) {
        Task {
            do {
                try await DevModeStore.shared.saveUploadedImage(image, for: seed)
                await MainActor.run {
                    imagePreviewMap[seed] = image
                    if !uploadedSeeds.contains(seed) {
                        uploadedSeeds.append(seed)
                        uploadedSeeds.sort()
                    }
                }
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }

    /// Delete image for a specific seed
    func deleteImage(for seed: String) {
        Task {
            do {
                try await DevModeStore.shared.deleteUploadedImage(for: seed)
                await MainActor.run {
                    uploadedSeeds.removeAll { $0 == seed }
                    imagePreviewMap.removeValue(forKey: seed)
                }
            } catch {
                print("Error deleting image: \(error)")
            }
        }
    }
}
