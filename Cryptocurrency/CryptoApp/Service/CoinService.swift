//
//  CoinService.swift
//  CryptoApp
//
//  Created by Ashutosh Singh on 04/08/2025.
//

import Foundation

class CoinService {
    
    private let url: URL

    init(urlString: String = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=20&page=1") {
        guard let constructedURL = URL(string: urlString) else {
            fatalError("Invalid URL string: \(urlString)")
        }
        self.url = constructedURL
    }
    
    func fetchCoins() async throws -> [Coin] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decodeCoins(from: data)
        } catch {
            print("DEBUG: Failed to fetch or decode coins: \(error)")
            throw error
        }
    }
    
    private func decodeCoins(from data: Data) throws -> [Coin] {
        let decoder = JSONDecoder()
        return try decoder.decode([Coin].self, from: data)
    }
}
