//
//  IAccountInteractor.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import CombineGRPC
import TinkoffInvestSDK
import Combine

protocol IAccountInteractor {

    func fetchAccount(id: String) -> AccountModel?
    func updateAccount(id: String, name: String?)
    
    func getPositions(accountId: String, isSandbox: Bool) -> AnyPublisher<PositionsResponse, RPCError>
    func getCurrencies() -> AnyPublisher<CurrenciesResponse, RPCError>
    func getOrderBook(figi: String) -> AnyPublisher<GetOrderBookResponse, RPCError>
    func payIn(accountId: String, quantity: Int64) -> AnyPublisher<SandboxPayInResponse, RPCError>
    func buy(accountId: String, figi: String, quantity: Int64) -> AnyPublisher<PostOrderResponse, RPCError>
    func closeSandboxAccount(id: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError>
}
