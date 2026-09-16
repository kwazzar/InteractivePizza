//
//  PizzaManager.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import Foundation

final class PizzaManager {
    private let dataSource: any PizzaDataSource
    private let service: PizzaService

    init(dataSource: any PizzaDataSource, service: PizzaService) {
        self.dataSource = dataSource
        self.service = service
    }

    func loadPizzas() async throws -> [Pizza] {
        do {
            let pizzas = try await service.fetchPizzas()
            try await dataSource.save(pizzas)
            return pizzas
        } catch {
            throw PizzaOperationError.loadFailed
        }
    }

    func imageData(for urlString: String) async throws -> Data {
        try await service.fetchImageData(from: urlString)
    }
}
