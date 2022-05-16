//
//  IBaseRouter.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

protocol IBaseRouter: AnyObject {
    func dismiss(animated: Bool)
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction])
    func present(_ controller: UIViewController, animated: Bool)
    func pop()
}
