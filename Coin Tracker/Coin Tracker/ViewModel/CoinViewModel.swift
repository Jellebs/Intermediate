//
//  CoinViewMoel.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import SwiftUI
import Combine

struct CoinViewModel: Identifiable {
    var id: UUID { return UUID() }
    
    private let coin: Coin
    
    var name: String {
        return coin.name ?? ""
    }
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
//        formatter.numberStyle = .currency
        return formatter.string(from: Double(coin.price ?? "") as NSNumber? ?? 0 ) ?? ""
    }
    var symbol: String {
        return coin.symbol?.lowercased() ?? ""
    }
    var color: Color {
        return Color(hex: coin.color ?? "")
    }
    var change: Double {
        return Double(coin.change ?? "0") ?? 0
    }
    var history: [Double] {
        var computedValues = [Double]()
        let sparkline = coin.sparkline
        let histNums = sparkline.map { value in
            Double(value ?? "0")!
            }
            
        let min = histNums.min() ?? 0
        let max = histNums.max() ?? 100
        
        
        for item in histNums {
            computedValues.append(item.converting(from: min...max, to: 0...1))
        }
        return computedValues
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}
