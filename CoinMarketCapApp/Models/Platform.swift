//
//  Platform.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import Foundation

struct Platform: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let token_address: String
}
