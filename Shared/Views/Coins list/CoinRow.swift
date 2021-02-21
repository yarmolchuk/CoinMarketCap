//
//  CoinRow.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 19.02.2021.
//

import SwiftUI

struct CoinRow: View {
    let icon: UIImage?
    let name: String
    let price: String
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                if (icon != nil) {
                    Image(uiImage: icon!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Color.gray
                }
            }
            .frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(price)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

struct CoinRowConnector: Connector {
    @Environment(\.imageCache) var imageCache
    let id: Coin.Id
    
    func map(graph: Graph) -> some View {
        let coin = graph.coin(id: id)
        
        return CoinRow(
            icon: imageCache.image(for: id),
            name: coin.name,
            price: coin.price
        )
    }
}
