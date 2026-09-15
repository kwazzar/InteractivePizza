//
//  HomeViewModel.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI
import UIKit

@Observable
final class HomeViewModel {
    var selectedIndex = 0
    var selectedSize: PizzaSize? = .medium
    var quantity = 1

    var pizzas: [Pizza] = []
    var isLoading = false
    var errorMessage: String?

    var pizzaImage: Image?
    var pizzaImageFailed = false

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

    var selectedPrice: Double {
        let unitPrice = selectedPizza?.variants
            .first { $0.size == (selectedSize ?? .medium) }?
            .price ?? 0
        return unitPrice * Double(quantity)
    }

    // MARK: - Loading

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            pizzas = try await service.fetchPizzas()
        } catch {
            errorMessage = "Помилка завантаження: \(error.localizedDescription)"
        }
    }

    func loadPizzaImage(for urlString: String) async {
        pizzaImageFailed = false
        pizzaImage = nil

        do {
            let data = try await service.fetchImageData(from: urlString)
            guard !Task.isCancelled else { return }
            guard let uiImage = UIImage(data: data) else {
                pizzaImageFailed = true
                return
            }
            pizzaImage = Image(uiImage: uiImage)
        } catch {
            guard !Task.isCancelled else { return }
            pizzaImageFailed = true
        }
    }
}