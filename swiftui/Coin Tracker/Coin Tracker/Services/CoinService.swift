//
//  CoinService.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//
import UIKit
import Foundation
import Combine

//https://api.coinranking.com/v2/coins?timePeriod=7d

final class CoinService {
//    let url = URL(string:"https://api.coinranking.com/v2/coins?timePeriod=7d&symbols[]=btc&symbols[]=eth&symbols[]=usdt&symbols[]=xrp&symbols[]=bch&symbols[]=ada&symbols[]=ltc&symbols[]=cro" )
    
    let symbol1 = ["btc,eth,usdt,xrp,bch,ada,ltc,cro"]
    //let symbols = ["&symbols[]=btc&symbols[]=eth&symbols[]=usdt&symbols[]=xrp&symbols[]=bch&symbols[]=ada&symbols[]=ltc&symbols[]=cro"]
    
    lazy var urlComponents: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.coinranking.com"
        component.path = "/v2/coins"
        component.queryItems = [
            URLQueryItem(name: "timePeriod", value: "7d"),
            URLQueryItem(name: "symbols[]", value: "btc"),
            URLQueryItem(name: "symbols[]", value: "eth"),
            URLQueryItem(name: "symbols[]", value: "usdt"),
            URLQueryItem(name: "symbols[]", value: "xrp"),
            URLQueryItem(name: "symbols[]", value: "bch"),
            URLQueryItem(name: "symbols[]", value: "ada"),
            URLQueryItem(name: "symbols[]", value: "ltc"),
            URLQueryItem(name: "symbols[]", value: "cro"),]
        return component
    } ()
    
    
    func getCoins() -> AnyPublisher<coinResponse, Error>? {
        guard let url = urlComponents.url else { return nil }
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: coinResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            
    }
}



let APIKey = "coinrankingd6144dcfcdeeac5639d9caaf35dc8db6b9b25317f46dedc6"
