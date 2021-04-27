//
//  CoinResponse.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import Foundation

struct coinResponse: Decodable {
    let status: String
    let data: coinData
}
