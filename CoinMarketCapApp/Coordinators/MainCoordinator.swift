//
//  MainCoordinator.swift
//  CoinMarketCapApp
//
//  Created by Pavel Kupreichyk on 11/4/19.
//  Copyright © 2019 Pavel Kupreichyk. All rights reserved.
//

import RxSwift
import UIKit

class MainCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        initMainVC()
        
        return Observable.never()
    }
    
    private func initMainVC() {
        let viewController = MainViewController.initFromStoryboard(name: "Main")
        viewController.viewModel = MainViewModel()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
