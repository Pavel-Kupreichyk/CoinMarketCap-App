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

class MainViewModel : ViewModelType {
    struct DynamicInput {}
    struct DynamicOutput {}
    
    struct StaticInput {
        let nextPage: Observable<Void>
    }
    
    struct StaticOutput {
        let cryptocurrencyList: Driver<[Cryptocurrency]>
    }
    
    public var dynamicInput: MainViewModel.DynamicInput?
    public var dynamicOutput: MainViewModel.DynamicOutput?
    
    private let coinMarketCapService: CoinMarketCapService
    private var currPage: Int
    
    init(coinMarketCapService: CoinMarketCapService = CoinMarketCapService()) {
        self.coinMarketCapService = coinMarketCapService;
        currPage = 1
    }
    
    public func setupStreams(input: MainViewModel.StaticInput) -> MainViewModel.StaticOutput {
        let cryptocurrencyList = input.nextPage
            .startWith(())
            .flatMap{ [weak self] _ -> Single<CryptocurrencyPage> in
                guard let self = self else {
                    fatalError("Self does not exist")
                    
                }
                let cryptoStream = self.coinMarketCapService.FetchCryptocurrencyMap(page: self.currPage)
                self.currPage += 1
                return cryptoStream
            }
            .map{$0.data}
            .asDriver(onErrorJustReturn: [])
        
        
        return StaticOutput(cryptocurrencyList: cryptocurrencyList)
    }
}
