//
//  UIView+Cells.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

extension UIView {

    class func initFromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? T
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
