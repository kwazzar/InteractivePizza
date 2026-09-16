//
//  InMemoryPizzaDataSource.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import Foundation

final class InMemoryPizzaDataSource: PizzaDataSource {
    private var storage: [Pizza] = []

    func fetchAll() async throws -> [Pizza] {
        storage
    }

    func save(_ pizzas: [Pizza]) async throws {
        storage = pizzas
    }
}
