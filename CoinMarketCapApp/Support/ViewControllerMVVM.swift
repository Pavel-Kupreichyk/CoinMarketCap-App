//
//  ViewType.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/5/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import UIKit
import RxSwift

class ViewControllerMVVM<VMType: ViewModelType>: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: VMType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    func setupBindings() {}
    func setupUI() {}
}
