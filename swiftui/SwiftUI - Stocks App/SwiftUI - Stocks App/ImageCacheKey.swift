//
//  ImageCacheKey.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//


import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
    
    
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self]}
        set { self[ImageCacheKey.self] = newValue }
    }
}
