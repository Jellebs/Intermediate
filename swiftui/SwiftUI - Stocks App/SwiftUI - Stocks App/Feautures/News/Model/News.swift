//
//  News.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import Foundation

struct News: Identifiable, Codable, Hashable {
    var id: UUID { return UUID()}
    var title: String
    var url: String
    var urlToImage: String?
    var imageUrl: String {
        return urlToImage?.replacingOccurrences(of: "http://", with: "https://") ?? "https://i.pinimg.com/564x/7b/28/98/7b2898990ae6ce6d6b277113d51b14e8.jpg"
    }
    
}

