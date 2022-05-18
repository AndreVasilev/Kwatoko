//
//  InstrumentsInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

final class InstrumentsInteractor {

    let sdk: TinkoffInvestSDK

    init(sdk: TinkoffInvestSDK) {
        self.sdk = sdk
    }
}

extension InstrumentsInteractor: IInstrumentsInteractor {

    func getShares() -> AnyPublisher<SharesResponse, RPCError> {
        return sdk.instrumentsService.getShares(with: .base)
    }
}
