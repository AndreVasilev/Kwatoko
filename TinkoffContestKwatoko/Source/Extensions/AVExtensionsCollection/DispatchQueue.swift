//
//  DispatchQueue.swift
//
//  Created by Andrey Vasilev on 04.03.2021.
//

import Foundation

extension DispatchQueue {

    static func background(_ background: @escaping () -> Void, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            background()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
