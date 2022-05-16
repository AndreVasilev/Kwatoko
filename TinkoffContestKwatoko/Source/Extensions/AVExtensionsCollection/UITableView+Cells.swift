//
//  UITableView+Cells.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(cellClass: T.Type?) {
        register(cellClass, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerNib<T: UITableViewCell>(cellClass: T.Type?) {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
