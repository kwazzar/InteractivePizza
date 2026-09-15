//
//  HomeViewModel.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

@Observable
@MainActor
final class HomeViewModel {
    var selectedIndex = 0
    var selectedSize: PizzaSize? = .medium
    var quantity = 1
    var isLoading = true

    var pizzas: [Pizza] = []
    var errorMessage: String?

    @MainActor private var pizzaImages: [String: Image] = [:]
    @MainActor private var failedImageURLs: Set<String> = []

    private let service: PizzaService
    
    init(service: PizzaService = .shared) {
        self.service = service
    }
    
    func pizzaImage(for urlString: String) -> Image? {
        pizzaImages[urlString]
    }
    
    func pizzaImageFailed(for urlString: String) -> Bool {
        failedImageURLs.contains(urlString)
    }

    // MARK: - Derived state

    var selectedPizza: Pizza? {
        guard pizzas.indices.contains(selectedIndex) else { return nil }
        return pizzas[selectedIndex]
    }

    var pizzaName: String { selectedPizza?.name ?? "" }
    var description: String { selectedPizza?.description ?? "" }

    func select(_ id: Pizza.ID?) {
        guard let id, let index = pizzas.firstIndex(where: { $0.id == id }) else { return }
        selectedIndex = index
    }

    var selectedPrice: Double {
        let unitPrice = selectedPizza?.variants
            .first { $0.size == (selectedSize ?? .medium) }?
            .price ?? 0
        return unitPrice * Double(quantity)
    }

    // MARK: - Loading

    func loadPizzas() async {

        do {
            pizzas = try await service.fetchPizzas()
            selectedIndex = pizzas.isEmpty ? 0 : min(1, pizzas.count - 1)
            selectedSize = selectedPizza?.defaultSize
        } catch {
            print("❌ fetchPizzas failed:", error)
            errorMessage = "Помилка завантаження: \(error.localizedDescription)"
        }
    }

    func load() async {
        isLoading = true
        await loadPizzas()
        await loadImages()
        errorMessage = nil
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        await load()
    }

    private func loadImages() async {
        await withTaskGroup(of: Void.self) { group in
            for pizza in pizzas where !pizza.imageURL.isEmpty {
                group.addTask { [self] in await loadImage(for: pizza.imageURL) }
            }
        }
    }

    private func loadImage(for urlString: String) async {
        await MainActor.run {
            guard pizzaImages[urlString] == nil, !failedImageURLs.contains(urlString) else { return }
        }

        do {
            let data = try await service.fetchImageData(from: urlString)
            guard !Task.isCancelled else { return }
            guard let uiImage = UIImage(data: data) else {
                _ = await MainActor.run {
                    failedImageURLs.insert(urlString)
                }
                return
            }
            _ = await MainActor.run {
                pizzaImages[urlString] = Image(uiImage: uiImage)
            }
        } catch {
            guard !Task.isCancelled else { return }
            _ = await MainActor.run {
                failedImageURLs.insert(urlString)
            }
        }
    }
}
