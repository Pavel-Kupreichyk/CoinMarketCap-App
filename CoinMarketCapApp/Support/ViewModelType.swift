//
//  ViewModelType.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype StaticInput
    associatedtype StaticOutput
    
    associatedtype DynamicInput
    associatedtype DynamicOutput
    
    var dynamicInput: DynamicInput? { get }
    var dynamicOutput: DynamicOutput? { get }
    
    func setupStreams(input: StaticInput) -> StaticOutput
}
