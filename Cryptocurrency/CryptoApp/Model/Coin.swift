//
//  Coin.swift
//  CryptoApp
//
//  Created by Ashutosh Singh on 04/08/2025.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: URL
    let currentPrice: Double
    let marketCapRank: Int
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(URL.self, forKey: .image)
        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        marketCapRank = try container.decode(Int.self, forKey: .marketCapRank)
        isFavorite = false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
        try container.encode(currentPrice, forKey: .currentPrice)
        try container.encode(marketCapRank, forKey: .marketCapRank)
    }
}
