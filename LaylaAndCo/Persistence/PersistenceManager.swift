// TODO(Phase 2): raise SWIFT_STRICT_CONCURRENCY to `complete` and audit
// Sendable conformance on Codable models flowing across this actor boundary.

import Foundation

actor PersistenceManager {
    static let shared = PersistenceManager()

    private let fileManager = FileManager.default
    private let profileFilename = "user_profile.json"

    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var profileURL: URL {
        documentsURL.appendingPathComponent(profileFilename)
    }

    func loadUserProfile() -> UserProfile? {
        guard fileManager.fileExists(atPath: profileURL.path),
              let data = try? Data(contentsOf: profileURL),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        else { return nil }
        return profile
    }

    func saveUserProfile(_ profile: UserProfile) throws {
        let data = try JSONEncoder().encode(profile)
        try data.write(to: profileURL, options: [.atomic])
    }

    func deleteUserProfile() throws {
        guard fileManager.fileExists(atPath: profileURL.path) else { return }
        try fileManager.removeItem(at: profileURL)
    }
}
