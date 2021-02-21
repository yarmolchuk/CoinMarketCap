//
//  API.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 20.02.2021.
//

import NetworkOperator
import Dispatch
import Core
import CoinMarketCapAPI
import Foundation

struct NetworkDriver {
    let store: Store
    let client: Client
    let `operator`: NetworkOperator
    
    var asObserver: Observer {
        Observer(queue: self.operator.queue) { state in
            self.observe(state: state)
            return .active
        }
    }
    
    func observe(state: AppState) {
        var requests = [NetworkOperator.Request]()
        
        defer {
            self.operator.process(props: requests)
        }
        
        func fire<Data: Decodable>(
            _ id: UUID,
            request: Client.Request<Data>,
            onComplete: @escaping (Client.Response<Data>) -> Action
        ) {
            requests.append(NetworkOperator.Request(
                id: id,
                request: request.urlRequest,
                handler: { data, response, error in
                    let result = request.handler(data, response, error)
                    let action = onComplete(result)
                    self.store.dispatch(action: action)
            }))
        }
        
        if let id = state.allCoins.request {
            fire(id, request: client.getAllActiveCryptocurrencies()) { response in
                guard case let .success(result) = response else {
                    preconditionFailure("Some error")
                }
                return ReceiveCoins(coins: result.asCoins)
            }
        }
    }
}

extension Client.AllActiveCryptocurrenciesResult.Result {
    var asCoreCoin: Core.Coin {
        Coin(
            id: Coin.Id(value: id),
            name: name,
            symbol: symbol,
            slug: slug,
            numMarketPairs: numMarketPairs,
            maxSupply: maxSupply,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            cmcRank: cmcRank,
            price: quote.usd.price
        )
    }
}

extension Client.AllActiveCryptocurrenciesResult {
    var asCoins: [Coin] {
        data.map(\.asCoreCoin)
    }
}
