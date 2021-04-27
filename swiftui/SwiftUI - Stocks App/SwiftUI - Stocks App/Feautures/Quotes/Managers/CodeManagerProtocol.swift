//
//  CodeManagerProtocol.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 06/04/2021.
//

import Foundation

protocol QuoteManagerProtocol {
    var quotes: [Quote] { get set }
    func download(stocks: [String], completion: @escaping(Result<[Quote], NetworkError>) -> Void)
    
    
}


