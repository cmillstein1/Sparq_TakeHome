//
//  PokemonViewModel.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemon: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: PokemonServiceProtocol
    private var nextURL: String?
    private var isFetching = false
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    func loadInitialPokemon() async {
        guard !isFetching else { return }
        
        isLoading = true
        errorMessage = nil
        isFetching = true
        
        defer {
            isLoading = false
            isFetching = false
        }
        
        do {
            let response = try await service.fetchPokemon(url: "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0")
            var pokemonWithImages = response.results
            await fetchImagesForPokemon(&pokemonWithImages)
            pokemon = pokemonWithImages
            nextURL = response.next
        } catch {
            errorMessage = "Failed to load Pokemon: \(error.localizedDescription)"
        }
    }
    
    func loadMorePokemon() async {
        guard let nextURL = nextURL,
              !isFetching,
              !isLoading else { return }
        
        isFetching = true
        
        do {
            let response = try await service.fetchPokemon(url: nextURL)
            var newPokemon = response.results
            await fetchImagesForPokemon(&newPokemon)
            pokemon.append(contentsOf: newPokemon)
            self.nextURL = response.next
        } catch {
            errorMessage = "Failed to load more Pokemon: \(error.localizedDescription)"
        }
        
        isFetching = false
    }
    
    private func fetchImagesForPokemon(_ pokemon: inout [Pokemon]) async {
        await withTaskGroup(of: (Int, String?, [String]).self) { group in
            for (index, pokemonItem) in pokemon.enumerated() {
                group.addTask {
                    var retries = 0
                    let maxRetries = 2
                    
                    while retries <= maxRetries {
                        do {
                            let detail = try await self.service.fetchPokemonDetail(url: pokemonItem.url)
                            let types = detail.types.map { $0.type.name }
                            return (index, detail.sprites.front_default, types)
                        } catch {
                            if retries < maxRetries {
                                retries += 1
                                try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retries - 1)) * 1_000_000_000))
                                continue
                            }
                            return (index, nil, [])
                        }
                    }
                    return (index, nil, [])
                }
            }
            
            for await (index, imageURL, types) in group {
                pokemon[index].imageURL = imageURL
                pokemon[index].types = types
            }
        }
    }
    
    var hasMorePokemon: Bool {
        nextURL != nil
    }
}
