//
//  PizzaService.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import Foundation

@MainActor
enum PizzaError: Error {
    case badURL
    case network(Error)
    case decoding(Error)
    case emptyResponse
}

@MainActor
final class PizzaService {
    static let shared = PizzaService()
    
    private let baseURL = "https://oursongapp.com/api/pizzas"
    
    private init() {}
    
    func fetchPizzas() async throws -> [Pizza] {
        guard let url = URL(string: baseURL) else {
            throw PizzaError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PizzaError.network(URLError(.badServerResponse))
        }
        
        do {
            let decoded = try JSONDecoder().decode(PizzasResponse.self, from: data)
            return decoded.pizzas.map { apiPizza in
                Pizza(
                    id: apiPizza.id,
                    name: apiPizza.name,
                    description: apiPizza.description,
                    imageURL: apiPizza.imageURL,
                    amount: 1,
                    price: Int((apiPizza.variants.first?.price ?? 0).rounded())
                )
            }
        } catch {
            throw PizzaError.decoding(error)
        }
    }
}
