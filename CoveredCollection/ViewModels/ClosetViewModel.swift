import Foundation
import Observation

@Observable
final class ClosetViewModel {
    var allProducts: [Product] = []
    var isLoading: Bool = false
    var selectedFilter: ProductCategory? = nil
    var respectDNA: Bool = true
    var sleeveOverride: SleeveLength? = nil

    func load() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(600))
        allProducts = MockData.products
        isLoading = false
    }

    func filtered(for dna: ModestyDNA) -> [Product] {
        var result = allProducts

        if let category = selectedFilter {
            result = result.filter { $0.category == category }
        }

        if respectDNA {
            var effectiveDNA = dna
            if let override = sleeveOverride {
                effectiveDNA.sleeve = override
            }
            result = result.filter { effectiveDNA.matches(product: $0.modestyDNA) }
        }

        return result
    }
}
