//
//  ImageCache.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 20.02.2021.
//

import SwiftUI
import Combine
import Core

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = ImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

class ImageCache {
    private var icons = [Coin.Id: UIImage]()
    
    func store(poster image: UIImage, for id: Coin.Id) {
        icons[id] = image
    }
    
    func hasPoster(for id: Coin.Id) -> Bool {
        return icons.keys.contains(id)
    }
    
    func image(for id: Coin.Id) -> UIImage? {
        icons[id]
    }
}
