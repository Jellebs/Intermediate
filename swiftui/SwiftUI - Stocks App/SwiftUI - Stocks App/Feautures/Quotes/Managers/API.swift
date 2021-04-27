//
//  API.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 06/04/2021.
//

import Foundation

struct API {
    static var baseURL: String {
        return "https://www.alphavantage.co/query?function="
    }
    static func symbolSearchUrl(for searchKey: String) -> String {
        return urlBy(symbol: .search, searchKey: searchKey)
    }
    static func quoteUrl(for searchKey: String) -> String {
        return urlBy(symbol: .quote, searchKey: searchKey)
    }
    
    
    private static func urlBy(symbol: SymbolFunction, searchKey: String) -> String {
        switch symbol {
        case .search:
            return "\(baseURL)\(symbol.rawValue)&apikey=\(key)&keywords=\(searchKey)"
        case .quote:
            return "\(baseURL)\(symbol.rawValue)=\(searchKey)&apikey=\(key)"
        }
        
        
    }
    enum SymbolFunction: String {
        case search = "SYMBOL_Search"
        case quote = "GLOBAL_QUOTE&symbol"
        
        
    }
}
extension API {
    static var key: String {
        return "MCVHV09PMJE5CGGE"
    }
}
