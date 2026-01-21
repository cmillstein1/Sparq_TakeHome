//
//  PokemonService.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

protocol PokemonServiceProtocol {
    func fetchPokemon(url: String) async throws -> PokemonResponse
    func fetchPokemonDetail(url: String) async throws -> PokemonDetail
}

class PokemonService: PokemonServiceProtocol {
    private let session: URLSession
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    nonisolated init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "pokemon_cache")
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            self.session = URLSession(configuration: configuration)
        }
    }
    
    func fetchPokemon(url: String) async throws -> PokemonResponse {
        return try await fetch(url: url, as: PokemonResponse.self)
    }
    
    func fetchPokemonDetail(url: String) async throws -> PokemonDetail {
        return try await fetch(url: url, as: PokemonDetail.self)
    }
    
    private func fetch<T: Decodable>(url: String, as type: T.Type, maxRetries: Int = 2) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var lastError: Error?
        
        for attempt in 0...maxRetries {
            do {
                let (data, response) = try await session.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                
                do {
                    return try Self.decoder.decode(type, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            } catch {
                lastError = error
                if attempt < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                    continue
                }
            }
        }
        
        throw lastError ?? NetworkError.invalidResponse
    }
}
