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
    @IBOutlet weak var cryptocurrencyTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    var stopRefreshAfterDrag = false
    
    override func setupUI() {
        cryptocurrencyTableView.refreshControl = refreshControl
        let nib = UINib(nibName: "CryptocurrencyTableViewCell", bundle: nil)
        cryptocurrencyTableView.register(nib, forCellReuseIdentifier: CryptocurrencyTableViewCell.reuseIdentifier)
    }

    override func setupBindings() {
        let inputs = CryptoListViewModel.StaticInput(
            incrementCurrPage: cryptocurrencyTableView.rx.contentOffset
                .filter({[weak self] offset in
                if let self = self, !self.activityIndicator.isAnimating {
                    return offset.y + self.cryptocurrencyTableView.frame.size.height + 20 >
                        self.cryptocurrencyTableView.contentSize.height
                }
                return false
                }).map {_ in},
            
            refresh: refreshControl.rx.controlEvent(.valueChanged).map{_ in}
        )
        
        let outputs = viewModel?.setupStreams(input: inputs)
        
        outputs?.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        outputs?.cryptocurrencyList
            .do(onNext: {[weak self] _ in
                if let self = self {
                    if self.cryptocurrencyTableView.isDragging {
                        self.stopRefreshAfterDrag = true
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                }
            })
            .drive(cryptocurrencyTableView.rx.items(cellIdentifier: CryptocurrencyTableViewCell.reuseIdentifier,
                                                    cellType: CryptocurrencyTableViewCell.self)) { [weak self] (_, currency, cell) in
                                                        self?.setupCryptocurrencyCell(cell: cell, withCryptocurrency: currency)
            }
            .disposed(by: disposeBag)
        
        cryptocurrencyTableView.rx.didEndDragging.subscribe(onNext: {[weak self] _ in
            if let self = self, self.stopRefreshAfterDrag {
                self.refreshControl.endRefreshing()
                self.stopRefreshAfterDrag = false
            }})
            .disposed(by: disposeBag)
    }

    private func setupCryptocurrencyCell(cell: CryptocurrencyTableViewCell, withCryptocurrency data: Cryptocurrency) {
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(data.id).png")
        cell.currencyImage.kf.setImage(with: url)
        cell.currencyNumber.text = String(data.cmc_rank)
        cell.currencyName.text = data.name
        
        if let quote = data.quote["USD"] {
            cell.currencyPrice.text = "$"+getFormattedPrice(quote.price)
            cell.percentChange.text = String(format:"%.2f", quote.percent_change_24h)+"%"
            if quote.percent_change_24h < 0 {
                cell.arrowImage.image = UIImage(named: "DownArrow")
                cell.percentChange.textColor = UIColor.red
                cell.arrowImage.tintColor = UIColor.red
            } else {
                cell.arrowImage.image = UIImage(named: "UpArrow")
                cell.arrowImage.tintColor = UIColor.green
                cell.percentChange.textColor = UIColor.green
            }
        } else {
            cell.currencyPrice.text = "-"
            cell.percentChange.text = "-"
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
