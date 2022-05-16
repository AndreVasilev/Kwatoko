//
//  UIViewController.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

extension UIViewController {

    static func initFromXib<T: UIViewController>() -> T? {
        return T(nibName: String(describing: T.self), bundle: nil)
    }
}
