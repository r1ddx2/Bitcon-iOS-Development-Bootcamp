//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    var delegate: CoinManagerDelegate? // Delegate handler
 
    let baseURL = "https://api.coincap.io/v2/assets?sort=marketcap&limit="
    let apiKey = "027ba36b-82ac-468c-982f-a3f4a74e1fb4"
    let rankTo = 24

    
    //    // Networking
    //    // Fetch Coin Ranking List
    func getCoinList() {
        // Complete URL
        let urlString = "\(baseURL)\(rankTo)&apikey=\(apiKey)"
        
        // 1. Create URL ?Make sure URL no typo
        if let url = URL(string: urlString){
            // 2. Create URL Session
            let session = URLSession(configuration: .default)
            // 3. Create URL Session DataTask
            let task = session.dataTask(with: url) { (data, response, error) in
                // If fail to retrieve data from url
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                // ?Make sure data successfully retrieve from url
                if let safeData = data {
                    // ?Make sure data successfully decoded
                    if let coinArray = self.parseJSON(safeData) {
                        // Get rank, symbol, price arrays
                        //self.delegate?.didUpdatePrice(coinArray)
                        // Pass symbol array
                        self.delegate?.didUpdateList(coinArray.symbolArray)
                    }
                }
            }
            // 4. Perform Request
            task.resume()
        }
    }
    
    // Fetch Coin Price
    func getCoinPrice(_ row: Int) {
        // Complete URL
        let urlString = "\(baseURL)\(rankTo)&apikey=\(apiKey)"
        // 1. Create URL ?Make sure URL no typo
        if let url = URL(string: urlString){
            // 2. Create URL Session
            let session = URLSession(configuration: .default)
            // 3. Create URL Session DataTask
            let task = session.dataTask(with: url) { (data, response, error) in
                // If fail to retrieve data from url
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                // ?Make sure data successfully retrieve from url
                if let safeData = data {
                    // ?Make sure data successfully decoded
                    if let coinArray = self.parseJSON(safeData) {
                        // Get rank, symbol, price arrays
                        //self.delegate?.didUpdatePrice(coinArray)
                        // Pass symbol array
                        let priceArray = priceFormatting(coinArray.priceArray[row])
                        self.delegate?.didUpdatePrice(priceArray, currency:  coinArray.symbolArray[row])
            
                    }
                }
            }
            // 4. Perform Request
            task.resume()
        }
    }
    
    // JSON Decode
    func parseJSON(_ data: Data) -> CoinModel? {
        // 1. Create Decoder
        let decoder = JSONDecoder()
        do {
            // 2. Decode data (Set format of type for decoded data and where to get data)
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            // 3. Access decoded data
            let ranks = decodedData.data.map { $0.rank }
            let symbols = decodedData.data.map { $0.symbol }
            let prices = decodedData.data.map { $0.priceUsd }
            
            // 4. Initialize Model and put in decoded data
            let coinData = CoinModel(rankArray: ranks, symbolArray: symbols, priceArray: prices)
            
            return coinData
        } catch {
            // If fail to decode data, return nil
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    // Price Formatting
    func priceFormatting(_ priceString: String) -> String {
        var price = "0"
        if let priceDouble = Double(priceString) {
            if priceDouble.truncatingRemainder(dividingBy: 1) == 0 || priceDouble >= 1000 {
                price = String(format: "%.0f", priceDouble)
            } else if priceDouble >= 100 {
                price = String(format: "%.1f", priceDouble)
            } else if priceDouble >= 10 {
                price = String(format: "%.2f", priceDouble)
            } else if priceDouble > 1 {
                price = String(format: "%.3f", priceDouble)
            } else {
                if let decimalIndex = priceString.firstIndex(where: { $0 != "0" && $0 != "." }) {
                    var nonZeroIndex = priceString.distance(from: priceString.startIndex, to: decimalIndex)
                    nonZeroIndex = nonZeroIndex + 2
                    price = String(format: "%.\(nonZeroIndex)f", priceDouble)
                }
            }
        }
        return price
    }
}
