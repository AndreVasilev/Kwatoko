//
//  AccountInteractor.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

final class AccountInteractor {

    let database: IDatabaseService
    let sdk: TinkoffInvestSDK

    init(sdk: TinkoffInvestSDK, database: IDatabaseService) {
        self.sdk = sdk
        self.database = database
    }
}

extension AccountInteractor: IAccountInteractor {

    func fetchAccount(id: String) -> AccountModel? {
        return database.fetchAccount(id: id)
    }
    
    func updateAccount(id: String, name: String?) {
        database.updateAccount(id: id, name: name)
    }

    func getPositions(accountId: String, isSandbox: Bool) -> AnyPublisher<PositionsResponse, RPCError> {
        return isSandbox
            ? sdk.sandboxService!.getPositions(accountID: accountId)
            : sdk.portfolioService.getPositions(accountID: accountId)
    }
    
    func getCurrencies() -> AnyPublisher<CurrenciesResponse, RPCError> {
        return sdk.instrumentsService.getCurrencies(with: .base)
    }
    
    func getOrderBook(figi: String) -> AnyPublisher<GetOrderBookResponse, RPCError> {
        return sdk.marketDataService.getOrderBook(figi: figi, depth: 1)
    }
    
    func payIn(accountId: String, quantity: Int64) -> AnyPublisher<SandboxPayInResponse, RPCError> {
        var amount = MoneyValue()
        amount.units = quantity
        amount.currency = "rub"
        return sdk.sandboxService!.payIn(accountID: accountId, amount: amount)
    }
    
    func buy(accountId: String, figi: String, quantity: Int64) -> AnyPublisher<PostOrderResponse, RPCError> {
        var request = PostOrderRequest()
        request.accountID = accountId
        request.figi = figi
        request.quantity = quantity
        request.direction = .buy
        request.orderType = .market
        return sdk.sandboxService!.postOrder(request: request)
    }
    
    func closeSandboxAccount(id: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError> {
        return sdk.sandboxService!.closeAccount(accountID: id)
    }}
