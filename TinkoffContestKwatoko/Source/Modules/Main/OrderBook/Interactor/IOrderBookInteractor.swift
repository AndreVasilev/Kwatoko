//
//  IOrderBookInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import Combine
import CombineGRPC

protocol IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher
    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError>
    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError>

    func storeHistory(trade: Trade)
}
