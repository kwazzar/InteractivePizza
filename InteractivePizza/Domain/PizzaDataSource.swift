//
//  PizzaDataSource.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

protocol PizzaDataSource {
    func fetchAll() async throws -> [Pizza]
    func save(_ pizzas: [Pizza]) async throws
}
