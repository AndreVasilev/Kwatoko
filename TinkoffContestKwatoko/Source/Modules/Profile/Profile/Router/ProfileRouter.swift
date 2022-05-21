//
//  ProfileRouter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK

final class ProfileRouter: BaseRouter {

    weak var rootDelegate: IRootPresenterDelegate?
    let accountAssembly: AccountAssembly

    init(rootDelegate: IRootPresenterDelegate?,
         accountAssembly: AccountAssembly) {
        self.rootDelegate = rootDelegate
        self.accountAssembly = accountAssembly
    }
}

extension ProfileRouter: IProfileRouter {

    func login() {
        rootDelegate?.didLogin()
    }

    func logout() {
        rootDelegate?.didLogout()
    }
    
    func showAccount(_ account: Account, isSandbox: Bool) {
        let controller = accountAssembly.build(account: account, isSandbox: isSandbox).viewController
        viewController?.show(controller, sender: nil)
    }
}
