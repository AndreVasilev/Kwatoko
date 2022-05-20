//
//  UIAlertController.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import UIKit

extension UIAlertController {

    convenience init(confirm message: String, action title: String, _ completion: @escaping () -> Void) {
        self.init(title: nil, message: message, preferredStyle: .alert)
        addAction(.init(title: "Отмена", style: .cancel))
        addAction(.init(title: title, style: .destructive, handler: { _ in completion() }))
    }
}
