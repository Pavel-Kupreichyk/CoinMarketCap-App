//
//  MainViewModel.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    private let coinMarketCapService: CoinMarketCapService
    
    init(coinMarketCapService: CoinMarketCapService = CoinMarketCapService()) {
        self.coinMarketCapService = coinMarketCapService;
        coinMarketCapService.FetchCryptocurrencyMap(page: 1)
    }
}
