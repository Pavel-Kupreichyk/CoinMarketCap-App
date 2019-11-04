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
    let elapsed: Int
    let credit_count: Int
}

struct Cryptocurrency: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let is_active: Int
    let first_historical_data: String
    let last_historical_data: String
    let platform: Platform?
}
