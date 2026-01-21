//
//  PokemonListView.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var isGridView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.pokemon.isEmpty && viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Button("Retry") {
                            Task {
                                await viewModel.loadInitialPokemon()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                } else {
                    Group {
                        if isGridView {
                            InfiniteGridView(
                                items: viewModel.pokemon,
                                hasMore: viewModel.hasMorePokemon,
                                onLoadMore: {
                                    await viewModel.loadMorePokemon()
                                }
                            ) { pokemon in
                                PokemonGridItem(pokemon: pokemon)
                            }
                            .id("grid-view")
                        } else {
                            InfiniteScrollView(
                                items: viewModel.pokemon,
                                hasMore: viewModel.hasMorePokemon,
                                onLoadMore: {
                                    await viewModel.loadMorePokemon()
                                }
                            ) { pokemon in
                                PokemonRow(pokemon: pokemon)
                            }
                            .id("list-view")
                        }
                    }
                }
            }
            .navigationTitle("Pokemon")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isGridView.toggle()
                        }
                    } label: {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
            .task {
                await viewModel.loadInitialPokemon()
            }
        }
    }
}

#Preview {
    PokemonListView()
}
