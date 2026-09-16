//
//  PizzaService.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import Foundation

actor PizzaService {
    private let session: URLSession
    private let baseURL = URL(string: "https://oursongapp.com/api/pizzas")!
    private var imageCache: [String: Data] = [:]
    
    init(session: URLSession = .shared) {
        self.session = session
        if URLCache.shared.diskCapacity == 0 {
            URLCache.shared.diskCapacity = 50 * 1024 * 1024 // 50MB
            URLCache.shared.memoryCapacity = 10 * 1024 * 1024 // 10MB
        }
    }
    
    func fetchPizzas() async throws -> [Pizza] {
        let data = try await fetchData(from: baseURL)
        return try await MainActor.run {
            try JSONDecoder().decode(PizzasResponse.self, from: data).pizzas.map { $0.toPizza() }
        }
    }
    
    func fetchImageData(from urlString: String) async throws -> Data {
        if let cached = imageCache[urlString] { return cached }
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        if let disk = ImageDiskCache.data(for: url) {
            imageCache[urlString] = disk
            return disk
        }

        let (data, _) = try await session.data(from: url)
        imageCache[urlString] = data
        Task { @MainActor in ImageDiskCache.set(data, for: url) }
        return data
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

private final class ImageDiskCache {
    nonisolated private static let directory: URL? = {
        guard let base = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        let dir = base.appendingPathComponent("PizzaImages", isDirectory: true)
        return (try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)) != nil ? dir : nil
    }()

    nonisolated static func data(for url: URL) -> Data? {
        guard let dir = directory else { return nil }
        return try? Data(contentsOf: dir.appendingPathComponent(fileName(for: url)))
    }

    nonisolated static func set(_ data: Data, for url: URL) {
        guard let dir = directory else { return }
        try? data.write(to: dir.appendingPathComponent(fileName(for: url)), options: .atomic)
    }

    nonisolated private static func fileName(for url: URL) -> String {
        (url.host ?? "host") + url.path.replacingOccurrences(of: "/", with: "_")
    }
}

// MARK: - Mapping

private extension ApiPizza {
    func toPizza() -> Pizza {
        Pizza(
            id: id,
            name: name,
            description: description,
            imageURL: imageURL,
            defaultSize: PizzaSize(rawValue: defaultSize) ?? .medium,
            variants: variants.compactMap { v in
                guard let size = PizzaSize(rawValue: v.size) else { return nil }
                return PizzaVariant(size: size, price: v.price)
            }
        )
    }
}
