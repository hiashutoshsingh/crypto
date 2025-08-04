//
//  ContentViewModel.swift
//  CryptoApp
//
//  Created by Ashutosh Singh on 04/08/2025.
//

import Foundation

@MainActor
class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var displayedCoins = [Coin]()
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let service = CoinService()
    private let favoritesKey = "favoriteCoins"
    
    init() {
        Task {
            do {
                try await fetchCoins()
                updateDisplayedCoins()
            } catch {
                print("Error fetching coins: \(error)")
            }
        }
    }
    
    func fetchCoins() async throws {
        self.coins = try await service.fetchCoins()
    }
    
    private func updateDisplayedCoins() {
        
        let favoriteIDs = Set(UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [])
        displayedCoins = coins.map { coin in
            var updatedCoin = coin
            updatedCoin.isFavorite = favoriteIDs.contains(coin.id)
            return updatedCoin
        }
        
    }
    
    func toggleFavorite(coin: Coin) {
        var favoriteIDs = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        var updatedCoin = coin
        updatedCoin.isFavorite.toggle()

        if updatedCoin.isFavorite {
            if !favoriteIDs.contains(updatedCoin.id) {
                favoriteIDs.append(updatedCoin.id)
            }
        } else {
            favoriteIDs.removeAll { $0 == updatedCoin.id }
        }

        UserDefaults.standard.setValue(favoriteIDs, forKey: favoritesKey)

        if let index = coins.firstIndex(where: { $0.id == updatedCoin.id }) {
            coins[index] = updatedCoin
        }

        updateDisplayedCoins()
    }
}
