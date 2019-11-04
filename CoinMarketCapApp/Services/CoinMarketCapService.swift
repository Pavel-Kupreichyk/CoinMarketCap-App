//
//  CoinMarketCapService.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//
import RxSwift
import RxAlamofire
import Foundation

class CoinMarketCapService {
    
    public enum SortType: String {
        case marketCap = "cmc_rank"
        case id
    }
    
    private enum HeaderName: String {
        case apiKey = "X-CMC_PRO_API_KEY"
        case accept = "Accept"
    }
    
    private enum ParameterName: String {
        case symbol
        case sort
        case start
        case limit
    }
    
    private let key = "464ee494-6f03-48cb-8425-80c051ae6628"
    private let baseURL = "https://pro-api.coinmarketcap.com/v1"
    
    public func FetchCryptocurrencyMap(sortType: SortType = .marketCap, page: Int, itemsPerPage: Int = 25) {
        let url = "\(baseURL)/cryptocurrency/map"
        let headers = [HeaderName.apiKey.rawValue: key,
                       HeaderName.accept.rawValue: "application/json"]
        
        let parameters: [String : Any] = [ParameterName.sort.rawValue: sortType.rawValue,
                                          ParameterName.limit.rawValue: itemsPerPage,
                                          ParameterName.start.rawValue: (page - 1) * itemsPerPage + 1]
        
        RxAlamofire.requestJSON(.get, url, parameters: parameters ,headers: headers)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (_, json) in
                if let data = try? JSONSerialization.data(withJSONObject: json) {
                    print(try! JSONDecoder().decode(CryptocurrencyPage.self, from: data))
                }
            })
    }
}
