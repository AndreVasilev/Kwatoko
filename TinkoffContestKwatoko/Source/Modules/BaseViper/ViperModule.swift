//
//  ViperModule.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

final class ViperModule<ViewController: UIViewController, Router> {
    let viewController: ViewController
    let router: Router

    init(viewController: ViewController, router: Router) {
        self.viewController = viewController
        self.router = router
    }
}
