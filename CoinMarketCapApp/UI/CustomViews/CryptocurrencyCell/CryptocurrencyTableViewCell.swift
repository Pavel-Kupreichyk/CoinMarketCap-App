//
//  CryptocurrencyTableViewCell.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/5/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import UIKit

class CryptocurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyName: UILabel!
    
    static let reuseIdentifier = "CryptocurrencyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
