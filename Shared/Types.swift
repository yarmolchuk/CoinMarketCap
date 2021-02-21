//
//  Types.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 18.02.2021.
//

import ReduxStore
import Core

typealias Action = Core.Action
typealias AppState = Core.AppState
typealias Coin = Core.Coin
typealias Graph = Core.Graph

typealias Store = ReduxStore.Store<AppState, Action>
typealias Observer = ReduxStore.Observer<AppState>
