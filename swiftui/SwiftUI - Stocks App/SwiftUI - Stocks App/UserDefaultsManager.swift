//
//  UserDefaultsManager.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import Foundation

final class userDefaultsManager {
    private static let symbolKey = "SYMBOL_KEY"
    
    var savedSymbols: [String] = ["Goog"]
    
    static let shared = userDefaultsManager()
    
    private init() {
        get()
    }

    func get() {
        if let saved = UserDefaults.standard.array(forKey: Self.symbolKey) as? [String] {
            savedSymbols = saved
        }
    }
    func set(symbol: String) {
        savedSymbols.append(symbol)
        UserDefaults.standard.setValue(self.savedSymbols, forKey: Self.symbolKey)
    }
}

