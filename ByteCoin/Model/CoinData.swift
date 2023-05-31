//
//  CoinData.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

// Create format for storing of decoded data
struct CoinData: Codable {
    // data[0].symbol
    let data: [RankData]
}

struct RankData: Codable {
    let rank: String
    let symbol: String
    let priceUsd: String
}

