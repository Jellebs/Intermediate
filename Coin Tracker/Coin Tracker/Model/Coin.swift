//
//  Coin.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import Foundation

struct Coin: Decodable {
    let name: String?
    let price: String?
    let symbol: String?
    let color: String?
    let change: String?
    let sparkline: [String?]
}
