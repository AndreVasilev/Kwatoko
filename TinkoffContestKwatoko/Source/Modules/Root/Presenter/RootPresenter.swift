//
//  RootPresenter.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import Foundation
import UIKit

final class RootPresenter: NSObject {

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
        if interactor.isAuthorized {
            presentMain()
        } else {
            presentLogin()
        }
    }

    func presentMain() {
        router.presentMain(delegate: self)
    }

    func presentLogin() {
        router.presentLogin(delegate: self)
    }
}

extension RootPresenter: IRootPresenter {

}

extension RootPresenter: IRootPresenterDelegate {

    func didLogout() {
        presentLogin()
    }

    func didLogin() {
        presentMain()
    }
}

extension RootPresenter: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard tabBarController.selectedViewController == viewController else { return true }
        let orderBookController = (viewController as? UINavigationController)?.viewControllers.last as? OrderBookViewController
        return orderBookController?.presenter.isRunning != true
    }
}
