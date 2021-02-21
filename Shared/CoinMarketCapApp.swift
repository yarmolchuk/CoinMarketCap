//
//  App.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 18.02.2021.
//

import SwiftUI
import Combine
import NetworkOperator
import CoinMarketCapAPI
import Core

@main
struct CoinMarketCap: App {
    @Environment(\.imageCache) var imageCache
    
    let store = Store(initial: AppState()) { state, action in
        print("Reduce\t\t\t", action)
        state.reduce(action)
    }
    let client = Client(
        baseURL: URL(string: "https://pro-api.coinmarketcap.com/v1/")!
    )

    let networkOperator = NetworkOperator()
    
    init() {
        networkOperator.enableTracing = true
        
        let networkDriver = NetworkDriver(store: store, client: client, operator: networkOperator)
        let imageLoader = ImageLoader(store: store, cache: imageCache)
        
        store.subscribe(observer: networkDriver.asObserver)
        store.subscribe(observer: imageLoader.asObserver)
    }
    
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                CoinsListConnector()
            }
        }
    }
}
