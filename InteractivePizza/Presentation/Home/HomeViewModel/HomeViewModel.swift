//
//  HomeViewModel.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

@Observable
final class HomeViewModel {
    var selectedIndex = 0
    var selectedSize: PizzaSize? = .medium
    var quantity = 1

    var pizzas: [Pizza] = []
    var errorMessage: String?

    var pizzaImages: [String: Image] = [:]
    var failedImageURLs: Set<String> = []

    private let service: PizzaService

    init(service: PizzaService = .shared) {
        self.service = service
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

    func pizzaImage(for urlString: String) -> Image? { pizzaImages[urlString] }
    func pizzaImageFailed(for urlString: String) -> Bool { failedImageURLs.contains(urlString) }

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
            errorMessage = "Помилка завантаження: \(error.localizedDescription)"
        }
    }

    func load() async {
        await loadPizzas()
        await loadAllImages()
    }

    private func loadAllImages() async {
        for pizza in pizzas {
            await loadPizzaImage(for: pizza.imageURL)
        }
    }

    func loadPizzaImage(for urlString: String) async {
        guard pizzaImages[urlString] == nil, !failedImageURLs.contains(urlString) else { return }

        do {
            let data = try await service.fetchImageData(from: urlString)
            guard !Task.isCancelled else { return }
            guard let uiImage = UIImage(data: data) else {
                failedImageURLs.insert(urlString)
                return
            }
            pizzaImages[urlString] = Image(uiImage: uiImage)
        } catch {
            guard !Task.isCancelled else { return }
            failedImageURLs.insert(urlString)
        }
    }
}
