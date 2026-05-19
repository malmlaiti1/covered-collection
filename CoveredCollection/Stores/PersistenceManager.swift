import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}

    private let profileKey = "userProfile"

    func saveUserProfile(_ profile: UserProfile) async throws {
        let data = try JSONEncoder().encode(profile)
        UserDefaults.standard.set(data, forKey: profileKey)
    }

    func loadUserProfile() async throws -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey) else { return nil }
        return try JSONDecoder().decode(UserProfile.self, from: data)
    }

    func deleteUserProfile() async throws {
        UserDefaults.standard.removeObject(forKey: profileKey)
    }
}
