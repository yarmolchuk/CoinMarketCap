//
//  Command.swift
//  CoinMarketCap
//
//  Created by Dima Yarmolchuk on 18.02.2021.
//

typealias Command = () -> ()
typealias CommandWith<T> = (T) -> ()

func nop() {}
func nop<T>(_ value: T) {}
