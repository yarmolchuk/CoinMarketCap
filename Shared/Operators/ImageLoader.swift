//
//  ImageLoader.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 20.02.2021.
//

import NetworkOperator
import Foundation
import Dispatch
import UIKit
import Core

class ImageLoader {
    internal init(store: Store, cache: ImageCache) {
        self.store = store
        self.cache = cache
        
        self.network.enableTracing = true
    }
    
    let network = NetworkOperator()
    let store: Store
    let cache: ImageCache
    
    var asObserver: Observer {
        Observer(queue: network.queue, observe: { state in
            self.observe(state: state)
            return .active
        })
    }
    
    private let baseURL = "https://s2.coinmarketcap.com/static/img/coins/64x64/"
    private var ids: [Coin.Id: UUID] = [:]
    
    func url(for icon: Coin.Id) -> URL {
        URL(string: baseURL + String(icon.value) + ".png")!
    }
    
    func observe(state: AppState) {
        let coins = state.allCoins.byId.keys
        
        // Generate uuids for request mapping
        for coin in coins where !ids.keys.contains(coin) {
            ids[coin] = UUID()
        }
        
        let requests: [NetworkOperator.Request] = coins.compactMap { coinId in
            let uuid = ids[coinId]!
            let urlRequest = URLRequest(
                url: url(for: state.allCoins.byId[coinId]!.id)
            )
            let operatorRequest = NetworkOperator.Request(
                id: uuid,
                request: urlRequest,
                handler: handler(coinId: coinId)
            )
            return operatorRequest
        }
        network.process(props: requests)
    }
    
    func handler(coinId: Coin.Id) -> (Data?, URLResponse?, Error?) -> () {
        return { data, response, error in
            guard let data = data else {
                preconditionFailure("No data in reponse")
            }
            guard let image = UIImage(data: data) else {
                preconditionFailure("Cannot read image")
            }
            DispatchQueue.main.sync {
                self.cache.store(poster: image, for: coinId)
            }
            self.store.dispatch(action: DidLoadIcon(coin: coinId))
        }
    }
}
