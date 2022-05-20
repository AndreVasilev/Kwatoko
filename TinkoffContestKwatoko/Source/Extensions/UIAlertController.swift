//
//  UIAlertController.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import UIKit

extension UIAlertController {

    convenience init(confirm message: String, action title: String, _ completion: @escaping () -> Void) {
        self.init(confirm: nil, message: message, actionTitle: title, completion)
    }

    convenience init(confirm title: String?, message: String, actionTitle: String, _ completion: @escaping () -> Void) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(.init(title: "Отмена", style: .cancel))
        addAction(.init(title: actionTitle, style: .destructive, handler: { _ in completion() }))
    }
}
