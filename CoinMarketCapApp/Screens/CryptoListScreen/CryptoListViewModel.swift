//
//  MainViewModel.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CryptoListViewModel : ViewModelType {
    struct DynamicInput {}
    struct DynamicOutput {}
    
    struct StaticInput {
        let incrementCurrPage: Observable<Void>
        let refresh: Observable<Void>
    }
    
    struct StaticOutput {
        let cryptocurrencyList: Driver<[Cryptocurrency]>
    }
    
    public var dynamicInput: CryptoListViewModel.DynamicInput?
    public var dynamicOutput: CryptoListViewModel.DynamicOutput?
    
    private let coinMarketCapService: CoinMarketCapService
    private var currPage: Int
    
    init(coinMarketCapService: CoinMarketCapService = CoinMarketCapService()) {
        self.coinMarketCapService = coinMarketCapService;
        currPage = 1
    }
    
    public func setupStreams(input: CryptoListViewModel.StaticInput) -> CryptoListViewModel.StaticOutput {
        let cryptocurrencyList = input.refresh
            .startWith(())
            .flatMap{ [weak self] _ -> Single<CryptocurrencyPage> in
                guard let self = self else {
                    fatalError("Self does not exist")
                }
                self.currPage = 1
                let cryptoStream = self.coinMarketCapService.FetchCryptocurrencies(page: self.currPage)
                return cryptoStream
            }
            .map{$0.data}
            .asDriver(onErrorJustReturn: [])
        
        return StaticOutput(cryptocurrencyList: cryptocurrencyList)
    }
}
