//
//  PokemonGridView.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct InfiniteGridView<Content: View, Item: Identifiable>: View {
    let items: [Item]
    let hasMore: Bool
    let onLoadMore: () async -> Void
    let content: (Item) -> Content
    
    @State private var isLoadingMore = false
    @State private var appeared = false
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    init(
        items: [Item],
        hasMore: Bool,
        onLoadMore: @escaping () async -> Void,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.hasMore = hasMore
        self.onLoadMore = onLoadMore
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.8)
                        .animation(
                            .spring(duration: 0.5)
                            .delay(Double(index) * 0.05),
                            value: appeared
                        )
                        .onAppear {
                            let threshold = max(6, items.count - 6)
                            if index >= threshold && hasMore && !isLoadingMore {
                                Task {
                                    isLoadingMore = true
                                    await onLoadMore()
                                    isLoadingMore = false
                                }
                            }
                        }
                }
                
                if isLoadingMore && hasMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .gridCellColumns(2)
                        .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .onAppear {
                appeared = true
            }
        }
    }
}

#Preview {
    InfiniteGridView(
        items: [
            Pokemon(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            Pokemon(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/"),
            Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ],
        hasMore: false,
        onLoadMore: {}
    ) { pokemon in
        PokemonGridItem(pokemon: pokemon)
    }
}
