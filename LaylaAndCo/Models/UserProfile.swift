import Foundation

struct UserProfile: Codable, Hashable {
    var firstName: String
    var modestyDNA: ModestyDNA
    var currentPlan: SubscriptionPlan?
    var queue: [UUID]
    var currentBox: [UUID]
    var savedProducts: Set<UUID>

    static let amina = UserProfile(
        firstName: "Amina",
        modestyDNA: .aminaDefault,
        currentPlan: nil,
        queue: [],
        currentBox: [],
        savedProducts: []
    )
}
