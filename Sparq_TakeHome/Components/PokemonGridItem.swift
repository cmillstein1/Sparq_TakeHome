//
//  PokemonGridItem.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct PokemonGridItem: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image("Pokeball_Placeholder")
                            .resizable()
                            .frame(width: 25, height: 25)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image("Pokeball_Placeholder")
                            .resizable()
                            .frame(width: 25, height: 25)
                    @unknown default:
                        Image("Pokeball_Placeholder")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .frame(width: 100, height: 100)
            } else {
                Image("Pokeball_Placeholder")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            
            Text(pokemon.name.capitalized)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            if !pokemon.types.isEmpty {
                HStack(spacing: 4) {
                    ForEach(pokemon.types, id: \.self) { type in
                        TypeSegment(typeName: type)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    PokemonGridItem(
        pokemon: Pokemon(
            name: "charizard",
            url: "https://pokeapi.co/api/v2/pokemon/6/",
            types: ["fire", "flying"]
        )
    )
    .padding()
}
