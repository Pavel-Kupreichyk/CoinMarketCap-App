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
        let isLoading: Driver<Bool>
    }
    
    public var dynamicInput: CryptoListViewModel.DynamicInput?
    public var dynamicOutput: CryptoListViewModel.DynamicOutput?
    
    private let coinMarketCapService: CoinMarketCapService
    
    init(coinMarketCapService: CoinMarketCapService = CoinMarketCapService()) {
        self.coinMarketCapService = coinMarketCapService;
    }
    
    public func setupStreams(input: CryptoListViewModel.StaticInput) -> CryptoListViewModel.StaticOutput {
        let isLoading = PublishSubject<Bool>()
        var cryptocurrencyList = [Cryptocurrency]()
        var currPage = 1
        
        let refreshList = input.refresh
            .startWith(())
            .flatMap{ [weak self] _ -> Single<CryptocurrencyPage> in
                guard let self = self else {
                    fatalError("Self does not exist")
                }
                currPage = 1
                isLoading.onNext(true)
                return self.coinMarketCapService.FetchCryptocurrencies(page: currPage)
            }
            .do(onNext: {cryptocurrencyList = $0.data})
        
        let updateList = input.incrementCurrPage
        .flatMap{ [weak self] _ -> Single<CryptocurrencyPage> in
            guard let self = self else {
                fatalError("Self does not exist")
            }
            currPage += 1
            isLoading.onNext(true)
            return self.coinMarketCapService.FetchCryptocurrencies(page: currPage)
        }
        .do(onNext: {cryptocurrencyList += $0.data})
        
        return StaticOutput(
            cryptocurrencyList: Observable.merge([refreshList, updateList])
                .map{_ in cryptocurrencyList}
                .do(onNext: {_ in isLoading.onNext(false)})
                .asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asDriver(onErrorJustReturn: false))
    }
}
