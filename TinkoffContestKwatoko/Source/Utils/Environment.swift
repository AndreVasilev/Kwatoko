//
//  EnvironmentService.swift
//
//  Created by Andrey Vasilev on 18.12.2020.
//

import Foundation

struct Environment: OptionSet {

    let rawValue: Int

    static let appstore = Environment(rawValue: 1 << 0)
    static let testflight = Environment(rawValue: 1 << 1)
    static let debug = Environment(rawValue: 1 << 2)

    static let develop: Environment = [testflight, debug]
    static let production = appstore
}

extension Environment {

    static var current: Environment {
        let environment: Environment
        #if DEBUG
        environment = .debug
        #else
        let path = Bundle.main.appStoreReceiptURL?.path
        if path?.contains("sandboxReceipt") == true
            || path?.contains("CoreSimulator") == true {
            environment = .testflight
        } else {
            environment = .appstore
        }
        #endif
        return environment
    }

    static func `is`(_ valid: Environment) -> Bool {
        return valid.contains(current)
    }
}
