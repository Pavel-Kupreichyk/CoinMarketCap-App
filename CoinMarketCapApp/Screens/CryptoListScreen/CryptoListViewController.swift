//
//  ViewController.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/1/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import UIKit
import RxSwift

class CryptoListViewController: ViewControllerMVVM<CryptoListViewModel>, StoryboardInitializable {

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
        cell.currencyName.text = data.name
    }
}
