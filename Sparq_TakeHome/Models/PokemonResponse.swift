//
//  PokemonResponse.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import Foundation

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let id: UUID
    let name: String
    let url: String
    var imageURL: String?
    var types: [String] = []
    
    init(id: UUID = UUID(), name: String, url: String, imageURL: String? = nil, types: [String] = []) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = imageURL
        self.types = types
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.imageURL = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct PokemonDetail: Codable {
    let sprites: PokemonSprites
    let types: [PokemonTypeSlot]
}

struct PokemonSprites: Codable {
    let front_default: String?
}

struct PokemonTypeSlot: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}
