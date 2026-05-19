import Foundation

// MARK: - Axis enums

enum Neckline: String, Codable, CaseIterable, Identifiable, Hashable {
    case high, modestScoop, vNeck, openOK
    var id: Self { self }
    var displayName: String {
        switch self {
        case .high:        return "High"
        case .modestScoop: return "Modest Scoop"
        case .vNeck:       return "V-Neck"
        case .openOK:      return "Open OK"
        }
    }
}

enum SleeveLength: String, Codable, CaseIterable, Identifiable, Hashable {
    case long, threeQuarter, elbow, short, sleevelessOK
    var id: Self { self }
    var displayName: String {
        switch self {
        case .long:          return "Long"
        case .threeQuarter:  return "3/4 Sleeve"
        case .elbow:         return "Elbow"
        case .short:         return "Short"
        case .sleevelessOK:  return "Sleeveless OK"
        }
    }
}

enum HemLength: String, Codable, CaseIterable, Identifiable, Hashable {
    case anklePlus, midi, knee, aboveKneeOK
    var id: Self { self }
    var displayName: String {
        switch self {
        case .anklePlus:    return "Ankle+"
        case .midi:         return "Midi"
        case .knee:         return "Knee"
        case .aboveKneeOK:  return "Above Knee OK"
        }
    }
}

enum Opacity: String, Codable, CaseIterable, Identifiable, Hashable {
    case fullyOpaque, linedRequired, sheerWithSlipOK
    var id: Self { self }
    var displayName: String {
        switch self {
        case .fullyOpaque:      return "Fully Opaque"
        case .linedRequired:    return "Lined Required"
        case .sheerWithSlipOK:  return "Sheer w/ Slip OK"
        }
    }
}

enum Silhouette: String, Codable, CaseIterable, Identifiable, Hashable {
    case veryLoose, relaxed, tailored, fittedOK
    var id: Self { self }
    var displayName: String {
        switch self {
        case .veryLoose: return "Very Loose"
        case .relaxed:   return "Relaxed"
        case .tailored:  return "Tailored"
        case .fittedOK:  return "Fitted OK"
        }
    }
}

// MARK: - ModestyTag

enum ModestyTag: String, Codable, CaseIterable, Identifiable, Hashable {
    case hijabFriendly, abayaWear, athleticModest, maternity, plusSize, petite
    var id: Self { self }
    var displayName: String {
        switch self {
        case .hijabFriendly:   return "Hijab-Friendly"
        case .abayaWear:       return "Abaya Wear"
        case .athleticModest:  return "Athletic Modest"
        case .maternity:       return "Maternity"
        case .plusSize:        return "Plus Size"
        case .petite:          return "Petite"
        }
    }
    var symbol: String {
        switch self {
        case .hijabFriendly:   return "circle.dashed.inset.filled"
        case .abayaWear:       return "figure.stand.dress"
        case .athleticModest:  return "figure.run"
        case .maternity:       return "figure.and.child.holdinghands"
        case .plusSize:        return "plus.diamond"
        case .petite:          return "minus.diamond"
        }
    }
}

// MARK: - ModestyDNA

struct ModestyDNA: Codable, Equatable, Hashable {
    var neckline: Neckline    = .modestScoop
    var sleeve: SleeveLength  = .long
    var hem: HemLength        = .midi
    var opacity: Opacity      = .fullyOpaque
    var silhouette: Silhouette = .relaxed
    var optionalTags: Set<ModestyTag> = []

    /// Returns true if `product` is at or within the user's permissiveness on every axis.
    func matches(product: ModestyDNA) -> Bool {
        rank(product.neckline,    in: Neckline.allCases)    <= rank(neckline,    in: Neckline.allCases)    &&
        rank(product.sleeve,      in: SleeveLength.allCases) <= rank(sleeve,      in: SleeveLength.allCases) &&
        rank(product.hem,         in: HemLength.allCases)    <= rank(hem,         in: HemLength.allCases)    &&
        rank(product.opacity,     in: Opacity.allCases)      <= rank(opacity,     in: Opacity.allCases)      &&
        rank(product.silhouette,  in: Silhouette.allCases)   <= rank(silhouette,  in: Silhouette.allCases)
    }

    private func rank<T: Equatable>(_ value: T, in cases: [T]) -> Int {
        cases.firstIndex(of: value) ?? 0
    }

    static let aminaDefault = ModestyDNA(
        neckline: .modestScoop,
        sleeve: .long,
        hem: .midi,
        opacity: .fullyOpaque,
        silhouette: .relaxed,
        optionalTags: [.hijabFriendly]
    )
}
