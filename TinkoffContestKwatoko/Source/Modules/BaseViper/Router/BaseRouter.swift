//
//  BaseRouter.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

class BaseRouter: NSObject {
    weak var viewController: UIViewController?
}

extension BaseRouter: IBaseRouter {

    func dismiss(animated: Bool) {
        viewController?.dismiss(animated: animated)
    }

    func present(_ controller: UIViewController, animated: Bool) {
        viewController?.present(controller, animated: animated, completion: nil)
    }

    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController?.present(alert, animated: true, completion: nil)
    }
}
