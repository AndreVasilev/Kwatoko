//
//  IOrderBookInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

protocol IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> AnyPublisher<OrderBook, RPCError>
}
