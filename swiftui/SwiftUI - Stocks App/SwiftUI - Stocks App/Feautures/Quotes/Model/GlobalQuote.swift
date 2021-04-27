//
//  GlobalQuote.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 05/04/2021.
//

import Foundation

struct GlobalQuoteResponse: Codable {
    var quote: Quote
    
    private enum CodingKeys: String, CodingKey {
        case quote = "Global Quote"
    }
}



