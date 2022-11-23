//
//  StrategiesPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class StrategiesPresenter: BasePresenter {

    typealias Callback = (Strategy) -> Void

    let interactor: IStrategiesInteractor
    let router: IStrategiesRouter

    var callback: Callback?

    let strategies: [Strategy] = [.contest, .demoContest, .buyingAnomaly, .demoBuyingAnomaly]

    init(interactor: IStrategiesInteractor, router: IStrategiesRouter, callback: Callback?) {
        self.interactor = interactor
        self.router = router
        self.callback = callback
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension StrategiesPresenter: IStrategiesPresenter {

    func didSelectRow(at indexPath: IndexPath) {
        let strategy = strategies[indexPath.row]

        callback?(strategy)
        if interactor.didOpenInfo(strategy: strategy) {
            router.pop()
        } else {
            interactor.setDidOpenInfo(strategy: strategy)
            router.firstShowInfo(strategy: strategy)
        }
    }

    func presentStrategyInfo(at indexPath: IndexPath) {
        let strategy = strategies[indexPath.row]
        router.showInfo(strategy: strategy)
    }
}
