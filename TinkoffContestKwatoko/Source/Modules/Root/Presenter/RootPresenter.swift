//
//  RootPresenter.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RootPresenter {

    let interactor: IRootInteractor
    let router: IRootRouter

    init(interactor: IRootInteractor, router: IRootRouter) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        presentInitialContorller()
    }
}

private extension RootPresenter {

    func presentInitialContorller() {
        router.presentMain()
    }
}

extension RootPresenter: IRootPresenter {

}

extension RootPresenter: IRootPresenterDelegate {

}
