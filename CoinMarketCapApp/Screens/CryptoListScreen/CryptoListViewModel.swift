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
        let loadNextPage: Observable<Void>
    }
    
    struct StaticOutput {
        let cryptocurrencyList: Driver<[Cryptocurrency]>
    }
    
    public var dynamicInput: CryptoListViewModel.DynamicInput?
    public var dynamicOutput: CryptoListViewModel.DynamicOutput?
    
    private let coinMarketCapService: CoinMarketCapService
    private var nextPage: Int
    
    init(coinMarketCapService: CoinMarketCapService = CoinMarketCapService()) {
        self.coinMarketCapService = coinMarketCapService;
        nextPage = 1
    }
    
    public func setupStreams(input: CryptoListViewModel.StaticInput) -> CryptoListViewModel.StaticOutput {
        let cryptocurrencyList = input.loadNextPage
            .startWith(())
            .flatMap{ [weak self] _ -> Single<CryptocurrencyPage> in
                guard let self = self else {
                    fatalError("Self does not exist")
                }
                let cryptoStream = self.coinMarketCapService.FetchCryptocurrencyMap(page: self.nextPage)
                self.nextPage += 1
                return cryptoStream
            }
            .map{$0.data}
            .asDriver(onErrorJustReturn: [])
        
        return StaticOutput(cryptocurrencyList: cryptocurrencyList)
    }
}
