import Foundation

protocol ProductRepository {
    func allProducts() async -> [Product]
    func product(id: UUID) async -> Product?
}

final class InMemoryProductRepository: ProductRepository {
    static let shared = InMemoryProductRepository()

    private var simulatedFirstLoad = true

    func allProducts() async -> [Product] {
        if simulatedFirstLoad {
            try? await Task.sleep(nanoseconds: 400_000_000)
            simulatedFirstLoad = false
        }
        return MockData.products
    }

    func product(id: UUID) async -> Product? {
        MockData.products.first { $0.id == id }
    }
}
