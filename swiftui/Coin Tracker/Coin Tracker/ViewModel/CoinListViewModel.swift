//
//  CoinListViewModel.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import SwiftUI
import Combine

class CoinListViewModel: ObservableObject {
    @Published var coins = [CoinViewModel]()
    
    private let coinService = CoinService()
    
    var cancellable: AnyCancellable?
    
    func getCoins() {
        guard let getCoins = coinService.getCoins() else {
            print("No data")
            return
        }
        
        cancellable = getCoins.sink(receiveCompletion: { err in
            print(err)
        }) { coinResp in
            
            if let coins = coinResp.data.coins {
                for coin in coins {
                    if coin.price != "0" {
                        self.coins.append(CoinViewModel(coin))
//                        self.coins = coins.map { CoinViewModel($0)}
                    }
                }
            }
        }
    }
}
