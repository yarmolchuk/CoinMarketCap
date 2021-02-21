//
//  CoinListResult.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 20.02.2021.
//

import CoinMarketCapAPI
import Foundation
import Core

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
