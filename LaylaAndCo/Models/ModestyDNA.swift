import Foundation

enum Neckline: String, Codable, CaseIterable, Identifiable, Hashable {
    case high, modestScoop, vNeck, openOK
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .high:        return "High"
        case .modestScoop: return "Modest scoop"
        case .vNeck:       return "V-neck"
        case .openOK:      return "Open neckline OK"
        }
    }
    var symbol: String { "rectangle.portrait.and.arrow.right" }
}

enum SleeveLength: String, Codable, CaseIterable, Identifiable, Hashable {
    case long, threeQuarter, elbow, short, sleevelessOK
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .long:         return "Long"
        case .threeQuarter: return "Three-quarter"
        case .elbow:        return "Elbow"
        case .short:        return "Short"
        case .sleevelessOK: return "Sleeveless OK"
        }
    }
    /// Higher number = more coverage. Used by filter logic.
    var coverage: Int {
        switch self {
        case .long: 4
        case .threeQuarter: 3
        case .elbow: 2
        case .short: 1
        case .sleevelessOK: 0
        }
    }
}

enum HemLength: String, Codable, CaseIterable, Identifiable, Hashable {
    case anklePlus, midi, knee, aboveKneeOK
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .anklePlus:   return "Ankle or longer"
        case .midi:        return "Midi"
        case .knee:        return "Knee"
        case .aboveKneeOK: return "Above knee OK"
        }
    }
    var coverage: Int {
        switch self {
        case .anklePlus: 3
        case .midi: 2
        case .knee: 1
        case .aboveKneeOK: 0
        }
    }
}

enum Opacity: String, Codable, CaseIterable, Identifiable, Hashable {
    case fullyOpaque, linedRequired, sheerWithSlipOK
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .fullyOpaque:     return "Fully opaque"
        case .linedRequired:   return "Lined required"
        case .sheerWithSlipOK: return "Sheer w/ slip OK"
        }
    }
    var coverage: Int {
        switch self {
        case .fullyOpaque: 2
        case .linedRequired: 1
        case .sheerWithSlipOK: 0
        }
    }
}

enum Silhouette: String, Codable, CaseIterable, Identifiable, Hashable {
    case veryLoose, relaxed, tailored, fittedOK
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .veryLoose: return "Very loose"
        case .relaxed:   return "Relaxed"
        case .tailored:  return "Tailored"
        case .fittedOK:  return "Fitted OK"
        }
    }
}

enum ModestyTag: String, Codable, CaseIterable, Identifiable, Hashable {
    case hijabFriendly, prayerFriendly, garmentCompatible, tichelFriendly, maternity
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .hijabFriendly:     return "Hijab friendly"
        case .prayerFriendly:    return "Prayer friendly"
        case .garmentCompatible: return "Garment compatible"
        case .tichelFriendly:    return "Tichel friendly"
        case .maternity:         return "Maternity"
        }
    }
    var symbol: String {
        switch self {
        case .hijabFriendly:     return "scarf"
        case .prayerFriendly:    return "moon.stars"
        case .garmentCompatible: return "tshirt"
        case .tichelFriendly:    return "crown"
        case .maternity:         return "figure.and.child.holdinghands"
        }
    }
}

struct ModestyDNA: Codable, Hashable {
    var neckline: Neckline
    var sleeve: SleeveLength
    var hem: HemLength
    var opacity: Opacity
    var silhouette: Silhouette
    var optionalTags: Set<ModestyTag>

    static let aminaDefault = ModestyDNA(
        neckline: .high,
        sleeve: .long,
        hem: .anklePlus,
        opacity: .fullyOpaque,
        silhouette: .relaxed,
        optionalTags: [.hijabFriendly, .prayerFriendly]
    )

    /// A product matches the user's DNA when its values offer >= the coverage the user wants.
    /// Neckline & silhouette are treated as exact-or-more-conservative matches.
    func matches(product: ModestyDNA) -> Bool {
        guard product.sleeve.coverage  >= self.sleeve.coverage,
              product.hem.coverage     >= self.hem.coverage,
              product.opacity.coverage >= self.opacity.coverage
        else { return false }

        let necklineOK: Bool
        switch self.neckline {
        case .high:        necklineOK = product.neckline == .high
        case .modestScoop: necklineOK = product.neckline == .high || product.neckline == .modestScoop
        case .vNeck:       necklineOK = product.neckline != .openOK
        case .openOK:      necklineOK = true
        }
        return necklineOK
    }
}
