//
//  PokemonRow.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Image("Pokeball_Placeholder")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        ZStack {
                            Image("Pokeball_Placeholder")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    @unknown default:
                        ZStack {
                            Image("Pokeball_Placeholder")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                .frame(width: 60, height: 60)
            } else {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    ProgressView()
                        .scaleEffect(0.8)
                }
                .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(pokemon.name.capitalized)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                if !pokemon.types.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(pokemon.types, id: \.self) { type in
                            TypeSegment(typeName: type)
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
    }
}

#Preview {
    PokemonRow(
        pokemon: Pokemon(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
            types: ["electric"]
        )
    )
    .padding()
}
