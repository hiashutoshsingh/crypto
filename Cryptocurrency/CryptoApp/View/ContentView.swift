//
//  ContentView.swift
//  CryptoApp
//
//  Created by Ashutosh Singh on 04/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
                List {
                    ForEach(viewModel.displayedCoins) { coin in
                        CoinRowView(coin: coin, viewModel: viewModel)
                    }
                }
                .listStyle(.plain)
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
    }
}


struct CoinRowView: View {
    let coin: Coin
    @ObservedObject var viewModel: CoinsViewModel

    var body: some View {
        HStack(spacing: 10) {
            Text("\(coin.marketCapRank)")
                .foregroundColor(Color.accentColor)
            
            AsyncImage(url: coin.image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(coin.name)
                    .fontWeight(.semibold)
                Text(coin.symbol.uppercased())
            }
            
            Spacer()
            
            Text("$\(coin.currentPrice.asCurrencyWith6Decimals())")
                    .bold()
            Button(action: {
                viewModel.toggleFavorite(coin: coin)
            }) {
                Image(systemName: coin.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            
        }
        .font(.footnote)
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}


extension Double {

    private var currencyFormatter: NumberFormatter {
          let formatter = NumberFormatter()
          formatter.usesGroupingSeparator = true
          formatter.minimumFractionDigits = 2
          formatter.maximumFractionDigits = 6
          return formatter
      }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
            if let formattedString = currencyFormatter.string(from: number) {
                return formattedString
            } else {
                return "0.00"
        }
    }

}
