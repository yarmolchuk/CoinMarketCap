//
//  CoinsList.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 19.02.2021.
//

import SwiftUI
import Core

struct CoinsList<CoinRow: View>: View {
    let ids: [Coin.Id]
    let loadNextPage: Command?
    
    let row: (Coin.Id) -> CoinRow
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ids, id:\.self) { id in
                    NavigationLink(
                        destination: details(id: id),
                        label: { row(id) }
                    )
                }
                
                if loadNextPage != nil {
                    Text("Loading...").onAppear(perform: loadNextPage)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("CoinMarketCap")
        }
    }
    
    func details(id: Coin.Id) -> some View {
        return Text("")
//        RiderDetailsConnector(id: id)
    }
}
