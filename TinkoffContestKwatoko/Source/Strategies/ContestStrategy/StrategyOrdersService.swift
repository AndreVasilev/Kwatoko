//
//  StrategyOrdersService.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

protocol StrategyOrdersService {
    
    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError>
    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError>
    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError>
}

class DemoOrdersService: StrategyOrdersService {
    
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
}
