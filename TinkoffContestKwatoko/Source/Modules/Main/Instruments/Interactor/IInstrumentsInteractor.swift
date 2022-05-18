//
//  IInstrumentsInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import Combine
import CombineGRPC

protocol IInstrumentsInteractor {

    func getShares() -> AnyPublisher<SharesResponse, RPCError>
}
