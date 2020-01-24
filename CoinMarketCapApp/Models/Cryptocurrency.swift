//
//  Cryptocurrency.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import Foundation

struct CryptocurrencyPage: Codable {
    let status: PageStatus
    let data: [Cryptocurrency]
}

struct PageStatus: Codable {
    let timestamp: String
    let error_code: Int
    let error_message: String?
    let notice: String?
    let elapsed: Int
    let credit_count: Int
}

struct Cryptocurrency: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let cmc_rank: Int
    let num_market_pairs: Int
    let last_updated: String
    let date_added: String
    let tags: [String]
    let platform: Platform?
    let quote: Dictionary<String, Quote>
    let circulating_supply: Double?
    let total_supply: Double?
    let max_supply: Double?
}

struct Quote: Codable {
    let price: Double
    let volume_24h: Double
    let percent_change_1h: Double
    let percent_change_24h: Double
    let percent_change_7d: Double
    let market_cap: Double?
    let last_updated: String
}
