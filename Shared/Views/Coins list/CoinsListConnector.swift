//
//  CoinsListConnector.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 19.02.2021.
//

import Core
import SwiftUI

struct CoinsListConnector: Connector {
    func map(graph: Graph) -> some View {
        let coinsList = {
            CoinsList(
                ids: graph.coinsList.ids,
                loadNextPage:  nil,
                row: { CoinRowConnector(id: $0) }
            )
        }
        return coinsList()
    }
}
