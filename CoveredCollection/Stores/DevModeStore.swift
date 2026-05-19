import UIKit

/// Debug-only store for managing dev mode state and uploaded product images.
/// Only compiled in #if DEBUG builds.
@Observable
final class DevModeStore {
    static let shared = DevModeStore()

    private static let devModeKey = "devModeEnabled"
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    // Hardcoded dev credentials. This is a debug-only gate; the password
    // lives in the binary regardless, so plaintext comparison is fine.
    private static let validUsername = "dev"
    private static let validPassword = "Nanoose2!"

    var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: Self.devModeKey)
        }
    }

    init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: Self.devModeKey)
    }

    // MARK: - Authentication

    /// Validate dev login credentials. Returns true on match.
    func authenticate(username: String, password: String) -> Bool {
        return username == Self.validUsername && password == Self.validPassword
    }

    /// Log out — disable dev mode.
    func logout() {
        isEnabled = false
    }

    // MARK: - File I/O

    /// Save an uploaded image to Documents/Products/<seed>/image.jpg
    func saveUploadedImage(_ image: UIImage, for seed: String) async throws {
        let folderURL = documentsURL.appendingPathComponent("Products").appendingPathComponent(seed)
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

        let fileURL = folderURL.appendingPathComponent("image.jpg")
        guard let jpgData = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "DevModeStore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image"])
        }
        try jpgData.write(to: fileURL)
    }

    /// Load an uploaded image from Documents/Products/<seed>/image.jpg
    func loadUploadedImage(for seed: String) -> UIImage? {
        let fileURL = documentsURL.appendingPathComponent("Products").appendingPathComponent(seed).appendingPathComponent("image.jpg")
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    /// Delete an uploaded image
    func deleteUploadedImage(for seed: String) async throws {
        let fileURL = documentsURL.appendingPathComponent("Products").appendingPathComponent(seed).appendingPathComponent("image.jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }

    /// Get all seeds that have uploaded images
    func getAllUploadedSeeds() -> [String] {
        let productsURL = documentsURL.appendingPathComponent("Products")
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: productsURL.path) else {
            return []
        }
        return contents.filter { seed in
            let fileURL = productsURL.appendingPathComponent(seed).appendingPathComponent("image.jpg")
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
    }
}
