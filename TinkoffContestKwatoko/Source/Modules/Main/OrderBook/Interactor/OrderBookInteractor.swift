//
//  OrderBookInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

final class OrderBookInteractor {

    let sdk: TinkoffInvestSDK

    var history = [Trade]()

    init(sdk: TinkoffInvestSDK) {
        self.sdk = sdk
//        test()
    }


//    var cancellables = Set<AnyCancellable>()
//    func test() {
//        sdk.sandboxService.getAccounts()
//            .sink { result in
//              switch result {
//              case .failure(let error):
//                  print(error)
//              case .finished:
//                  print("did finish loading accounts")
//              }
//            } receiveValue: { [weak self] in
//                print($0.accounts)
//                if let account = $0.accounts.first {
//                    self?.getPortfolio(accountID: account.id)
//                } else {
//                    self?.openSandboxAccount()
//                }
//            }.store(in: &cancellables)
//    }
//
//    func getPortfolio(accountID: String) {
//        sdk.sandboxService.getPortfolio(accountID: accountID)
//            .sink { result in
//              switch result {
//              case .failure(let error):
//                  print(error)
//              case .finished:
//                  print("did finish getPortfolio")
//              }
//            } receiveValue: { [weak self] in
//                print($0)
//                if $0.totalAmountCurrencies.asMoneyAmount.value == 0 {
//                    self?.payInSandboxAccount(id: accountID)
//                }
//            }.store(in: &cancellables)
//    }
//
//    func openSandboxAccount() {
//        sdk.sandboxService.openAccount()
//            .sink { result in
//              switch result {
//              case .failure(let error):
//                  print(error)
//              case .finished:
//                  print("did finish openAccount")
//              }
//            } receiveValue: { [weak self] in
//                print($0)
//                self?.payInSandboxAccount(id: $0.accountID)
//            }.store(in: &cancellables)
//    }
//
//    func payInSandboxAccount(id: String) {
//        var amount = MoneyValue()
//        amount.units = 1000
//        amount.currency = "rub"
//        sdk.sandboxService.payIn(accountID: id, amount: amount)
//            .sink { result in
//              switch result {
//              case .failure(let error):
//                  print(error)
//              case .finished:
//                  print("did finish payIn")
//              }
//            } receiveValue: {
//                print($0)
//            }.store(in: &cancellables)
//    }
}

extension OrderBookInteractor: IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher {
        return sdk.marketDataServiceStream.subscribeToOrderBook(figi: figi, depth: depth)
    }

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return sdk.sandboxService.postOrder(request: request)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        return sdk.sandboxService.getOrderState(accountID: accountID, orderID: orderID)
    }

    func storeHistory(trade: Trade) {
        history.append(trade)
    }
}