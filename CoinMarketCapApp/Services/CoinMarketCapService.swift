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
        case marketCap = "market_cap"
        case percentChange24 = "percent_change_24h"
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
    
    public func FetchCryptocurrencies(sortType: SortType = .marketCap, page: Int, itemsPerPage: Int = 25) -> Single<CryptocurrencyPage> {
        let url = "\(baseURL)/cryptocurrency/listings/latest"
        let headers = [HeaderName.apiKey.rawValue: key,
                       HeaderName.accept.rawValue: "application/json"]
        
        let parameters: [String : Any] = [ParameterName.sort.rawValue: sortType.rawValue,
                                          ParameterName.limit.rawValue: itemsPerPage,
                                          ParameterName.start.rawValue: (page - 1) * itemsPerPage + 1]
        
        return RxAlamofire.requestJSON(.get, url, parameters: parameters, headers: headers)
            .map{(_, json) -> CryptocurrencyPage in
                guard let data = try? JSONSerialization.data(withJSONObject: json),
                let result = try? JSONDecoder().decode(CryptocurrencyPage.self, from: data) else {
                    fatalError("Unable to parse JSON")
                }
                return result
            }.asSingle()
    }
}
