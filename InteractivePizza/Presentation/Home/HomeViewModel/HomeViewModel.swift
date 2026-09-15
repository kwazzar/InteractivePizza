//
//  HomeViewModel.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    var pizzas: [Pizza] = []
    var isLoading = false
    var errorMessage: String?
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            pizzas = try await PizzaService.shared.fetchPizzas()
        } catch {
            errorMessage = "Помилка завантаження: \(error.localizedDescription)"
        }
    }
}
