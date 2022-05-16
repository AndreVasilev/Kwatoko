//
//  AppError.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IAppError: Error {
    var description: String { get }
}

enum AppError: IAppError {
    case unknown(String)
}

extension AppError {

    var description: String {
        switch self {
        case .unknown(let description): return description
        }
    }
}

extension Error {

    var description: String {
        if let error = self as? IAppError {
            return "\(error.description)"
        } else {
            return "\(self)"
        }
    }

    func print() {
        Swift.print("⚠️ \(self.description)")
    }
}
