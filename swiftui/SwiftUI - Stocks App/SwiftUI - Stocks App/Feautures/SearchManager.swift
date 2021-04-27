//
//  SearchManager.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import Foundation

final class SearchManager: ObservableObject {
    @Published var searches = [Search]()
    var udenforUS = "Ikke en US Stock"
    var ubekendt = "Ubekendt"


    func searchStocks(keyword: String) {
        if let url = URL(string: API.symbolSearchUrl(for: keyword)) {
            NetworkManager<SearchResponse>().fetch(from: url) { result in
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let resp):
                    DispatchQueue.main.async {
                        self.searches = resp.bestMatches
                        if resp.bestMatches.isEmpty {
                            let search = Search(symbol: "Ikke en US Stock", name: "", type: "")
                            self.searches = [search]
                        }
                    }
                }
            }
        } else {
            let search = Search(symbol: "Ukendt", name: "", type: "")
            self.searches = [search]
        }
    }
}
