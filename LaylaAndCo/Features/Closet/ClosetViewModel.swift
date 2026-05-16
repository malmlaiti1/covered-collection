import SwiftUI
import Observation

@MainActor
@Observable
final class ClosetViewModel {
    var allProducts: [Product] = []
    var isLoading: Bool = true
    var selectedFilter: ProductCategory? = nil
    var respectDNA: Bool = true
    /// Optional override for sleeve coverage when the user "loosens" the filter mid-demo.
    var sleeveOverride: SleeveLength? = nil

    private let repository: ProductRepository

    init(repository: ProductRepository = InMemoryProductRepository.shared) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        let items = await repository.allProducts()
        await MainActor.run {
            self.allProducts = items
            self.isLoading = false
        }
    }

    func filtered(for dna: ModestyDNA) -> [Product] {
        var effective = dna
        if let override = sleeveOverride {
            effective.sleeve = override
        }
        var items = allProducts
        if respectDNA {
            items = items.filter { effective.matches(product: $0.modestyDNA) }
        }
        if let cat = selectedFilter {
            items = items.filter { $0.category == cat }
        }
        return items
    }
}
