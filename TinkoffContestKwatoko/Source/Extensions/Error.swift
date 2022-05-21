//
//  Error.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 21.05.2022.
//

import Foundation
import CombineGRPC

extension Error {
    
    var alertMessage: String {
        let text: String
        if let rpcError = self as? RPCError,
           let message = rpcError.trailingMetadata?.first(name: "message") {
            text = message
        } else {
            text = localizedDescription
        }
        return text
    }
}
