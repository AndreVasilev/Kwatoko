//
//  DemoOrdersService.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

class DemoOrdersService: OrdersService {
    
    private var orders = [String: MoneyValue]()
 
    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        var response = PostOrderResponse()
        response.figi = request.figi
        response.executionReportStatus = .executionReportStatusNew
        response.orderID = UUID().uuidString
        var price = MoneyValue()
        price.units = request.price.units
        price.nano = request.price.nano
        price.currency = "rub"
        response.initialSecurityPrice = price
        
        orders[response.orderID] = price
        
        return Just(response)
            .setFailureType(to: RPCError.self)
            .eraseToAnyPublisher()
    }
    
    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        var response = OrderState()
        response.executionReportStatus = .executionReportStatusFill
        response.orderID = orderID
        response.initialSecurityPrice = orders[orderID]!
        return Just(response)
            .setFailureType(to: RPCError.self)
            .eraseToAnyPublisher()
    }
    
    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        let response = CancelOrderResponse()
        return Just(response)
            .setFailureType(to: RPCError.self)
            .eraseToAnyPublisher()
    }
    
    func getOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError> {
        let response = GetOrdersResponse()
        // Fill if needed
        return Just(response)
            .setFailureType(to: RPCError.self)
            .eraseToAnyPublisher()
    }
}
