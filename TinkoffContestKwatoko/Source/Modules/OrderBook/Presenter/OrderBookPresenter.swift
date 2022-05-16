//
//  OrderBookPresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import Combine
import TinkoffInvestSDK

final class OrderBookPresenter: BasePresenter {

    let interactor: IOrderBookInteractor
    let router: IOrderBookRouter

    let appName = "AndreVasilev.TinkoffInvestSwiftSDK"
    let fullAccessTokenProvider = DefaultTokenProvider(token: "")
    let readOnlyTokenProvider = DefaultTokenProvider(token: "")
    let sandboxTokenProvider = DefaultTokenProvider(token: "")

    lazy var sdk = TinkoffInvestSDK(appName: appName,
                                    tokenProvider: readOnlyTokenProvider,
                                    sandbox: sandboxTokenProvider)
    var cancellables = Set<AnyCancellable>()

    init(interactor: IOrderBookInteractor, router: IOrderBookRouter) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {

    }
}

private extension OrderBookPresenter {

    func testing() {

        sdk.userService.getAccounts().flatMap { [unowned self] in
            self.sdk.portfolioService.getPortfolio(accountID: $0.accounts.first!.id)
        }.sink { result in
          switch result {
          case .failure(let error):
              print(error)
          case .finished:
              print("did finish loading getPortfolio")
          }
        } receiveValue: { portfolio in
          print(portfolio.totalAmountCurrencies.asMoneyAmount.value)
        }.store(in: &cancellables)

        sdk.sandboxService.getAccounts()
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish loading accounts")
              }
            } receiveValue: {
                print($0.accounts)
            }.store(in: &cancellables)

        sdk.instrumentsService.getShares(with: .base)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish loading instruments")
              }
            } receiveValue: { [weak self] in
                let ticker = "SBER"
                if let share = $0.instruments.first(where: { $0.ticker == ticker }) {
                    print(share)
                    self?.subscribeToOrderBook(figi: share.figi)
                } else {
                    print("Share \(ticker) not found")
                }
            }.store(in: &cancellables)


    }

    func subscribeToOrderBook(figi: String) {
        sdk.marketDataServiceStream.subscribeToOrderBook(figi: figi, depth: 20)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish loading marketDataServiceStream")
              }
            } receiveValue: { dto in
              print(dto)
            }.store(in: &cancellables)
    }
}

extension OrderBookPresenter: IOrderBookPresenter {

}
