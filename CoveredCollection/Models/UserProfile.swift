import Foundation

struct UserProfile: Codable {
    var firstName: String = "Amina"
    var currentPlan: SubscriptionPlan? = nil
    var modestyDNA: ModestyDNA = .aminaDefault
    var savedProducts: Set<UUID> = []
    var currentBox: [UUID] = []
    var queue: [UUID] = []
}
