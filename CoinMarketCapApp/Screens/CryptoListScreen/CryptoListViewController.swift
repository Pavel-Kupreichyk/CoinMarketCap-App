//
//  ViewController.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/1/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class CryptoListViewController: ViewControllerMVVM<CryptoListViewModel>, StoryboardInitializable {
    //https://s2.coinmarketcap.com/static/img/coins/64x64/4.png
    @IBOutlet weak var cryptocurrencyTableView: UITableView!

    override func setupUI() {
        let nib = UINib(nibName: "CryptocurrencyTableViewCell", bundle: nil)
        cryptocurrencyTableView.register(nib, forCellReuseIdentifier: CryptocurrencyTableViewCell.reuseIdentifier)
    }

    override func setupBindings() {
        let inputs = CryptoListViewModel.StaticInput(loadNextPage: Observable.never())
        let outputs = viewModel?.setupStreams(input: inputs)

        outputs?.cryptocurrencyList
            .drive(cryptocurrencyTableView.rx.items(cellIdentifier: CryptocurrencyTableViewCell.reuseIdentifier,
                                                    cellType: CryptocurrencyTableViewCell.self)) { [weak self] (_, currency, cell) in
                                                        self?.setupCryptocurrencyCell(cell: cell, withCryptocurrency: currency)
            }
            .disposed(by: disposeBag)
    }

    private func setupCryptocurrencyCell(cell: CryptocurrencyTableViewCell, withCryptocurrency data: Cryptocurrency) {
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(data.id).png")
        cell.currencyImage.kf.setImage(with: url)
        cell.currencyNumber.text = String(data.cmc_rank)
        cell.currencyName.text = data.name
        
        if let price = data.quote["USD"]?.price {
            cell.currencyPrice.text = "$"+getFormattedPrice(price)
        } else {
            cell.currencyPrice.text = "-"
        }
    }
    
    private func getFormattedPrice(_ price: Double) -> String {
        var rank = 5
        var p = price
        while(p > 1) {
            p /= 10
            rank -= rank > 0 ? 1 : 0
        }
        return String(format:"%.*f", rank, price)
    }
}
