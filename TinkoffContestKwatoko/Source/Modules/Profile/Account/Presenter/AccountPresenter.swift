//
//  AccountPresenter.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import TinkoffInvestSDK
import Combine
import CombineGRPC

protocol IAccountPosition {
    var name: String { get }
    var value: String { get }
}

final class AccountPresenter: BasePresenter {

    enum Section {
        case info, currencies
        
        var title: String? {
            switch self {
            case .info: return nil
            case .currencies: return "Валюты"
            }
        }
    }
    
    enum InfoRow {
        case info, reload, close
    }
    
    enum Action: IRowAction {
        case close, reload
        
        var title: String {
            switch self {
            case .reload: return "Обновить"
            case .close: return "Закрыть"
            }
        }
        
        var color: UIColor {
            switch self {
            case .reload: return .systemBlue
            case .close: return .systemRed
            }
        }
    }
    
    struct Info {
        let name: String?
        let id: String
        let canEdit: Bool
        let openedDate: Date
    }
    
    struct CurrencyModel: IAccountPosition {
        let name: String
        let value: String
        let quantity: Decimal
        let currency: String
        let payInEnabled: Bool
    }
    
    let interactor: IAccountInteractor
    let router: IAccountRouter
    weak var viewController: IAccountView?
    let account: Account
    let isSandbox: Bool
    lazy var accountModel = interactor.fetchAccount(id: account.id)
    
    var cancellables = Set<AnyCancellable>()
    
    private var positions: PositionsResponse?
    private var currencies: [Currency]?
    var currencyModels = [CurrencyModel]()
    
    var isProcessing: Bool = false {
        didSet {
            viewController?.isProcessing = isProcessing
        }
    }

    init(interactor: IAccountInteractor, router: IAccountRouter, account: Account, isSandbox: Bool) {
        self.interactor = interactor
        self.router = router
        self.account = account
        self.isSandbox = isSandbox
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reloadPortfolio()
    }
    
    override func handleError(_ error: Error) {
        handleError(error, style: .alert)
    }
}

private extension AccountPresenter {
    
    func closeAccount() {
        let accountId = account.id
        let info = self.info
        let message = info.name ?? info.id
        let alert = UIAlertController(confirm: "Вы уверены, что хотите закрыть счёт?", message: message, actionTitle: "Закрыть") { [weak self] in
            self?.closeAccount(id: accountId)
        }
        router.present(alert, animated: true)
    }
    
    func closeAccount(id: String) {
        guard !isProcessing else { return }
        isProcessing = true
        interactor.closeSandboxAccount(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isProcessing = false
                switch $0 {
                case .failure(let error):
                    self?.handleError(error)
                case .finished:
                    self?.router.pop()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func reloadPortfolio() {
        guard !isProcessing else { return }
        isProcessing = true
        getPositions { [weak self] in
            if let error = $0 {
                self?.handleError(error)
                self?.isProcessing = false
            } else {
                self?.getCurrencies {
                    if let error = $0 {
                        self?.handleError(error)
                    } else {
                        self?.reloadCurrencyModels()
                    }
                    self?.isProcessing = false
                }
            }
        }
    }
    
    func getPositions(_ completion: @escaping (Error?) -> Void) {
        interactor.getPositions(accountId: account.id, isSandbox: isSandbox)
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let error): completion(error)
                case .finished: completion(nil)
                }
            } receiveValue: { [weak self] in
                self?.positions = $0
            }
            .store(in: &cancellables)
    }
    
    func getCurrencies(_ completion: @escaping (Error?) -> Void) {
        interactor.getCurrencies()
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let error): completion(error)
                case .finished: completion(nil)
                }
            } receiveValue: { [weak self] in
                self?.currencies = $0.instruments
            }
            .store(in: &cancellables)
    }
    
    func reloadCurrencyModels() {
        var models = [CurrencyModel]()
        
        let rub = MoneyCurrency.rub
        let rubQuantity = positions?.money.first(where: { $0.currency.lowercased() == rub.rawValue.lowercased() })?.asMoneyAmount.value ?? 0
        models.append(CurrencyModel(name: "Рубль",
                                    value: "\(rubQuantity) \(rub.sign)",
                                    quantity: rubQuantity,
                                    currency: rub.rawValue.lowercased(),
                                    payInEnabled: isSandbox))
        
        let currencyModels: [CurrencyModel] = (currencies ?? [])
            .map { currency in
                let currencyValue = currency.nominal.currency
                let position = positions?.money.first(where: { $0.currency.lowercased() == currencyValue.lowercased() })
                let quantity = position?.asMoneyAmount.value ?? 0
                let payInEnabled = isSandbox
                    && currency.buyAvailableFlag
                    && currency.apiTradeAvailableFlag
                    && currency.tradingStatus == .normalTrading
                
                return CurrencyModel(name: currency.name,
                                     value: "\(quantity) \(MoneyCurrency(rawValue: currencyValue)?.sign ?? "")",
                                     quantity: quantity,
                                     currency: currencyValue,
                                     payInEnabled: payInEnabled)
            }
            .sorted(by: { $0.quantity > $1.quantity })
        models.append(contentsOf: currencyModels)
        self.currencyModels = models
            
        viewController?.reloadData()
    }
    
    func payIn(currency moneyCurrency: MoneyCurrency) {
        let message = moneyCurrency == .rub
            ? "Введите сумму, на которую хотите совершить пополнение"
            : "Пополнение доступно только в рублях.\nЧтобы пополнить другую валюту, будет совершено пополнение в рублях на сумму приблизительно эквивалентную сумме валюты с последующей покупкой указанной валюты\nЕсли произойдет ошибка - попробуйте указать меньшую сумму\n\nПокупка иностранной валюты может происходить с задержкой из-за особенностей работы песочницы. Если обновление баланса не произойдет моментально - попробуйте вернуться позже и проверить баланс снова"
        let payInAlert = UIAlertController(title: "Пополнение",
                                           message: message,
                                           preferredStyle: .alert)
        payInAlert.addTextField {
            $0.keyboardType = .numberPad
            $0.placeholder = "Сумма пополнения"
        }
        payInAlert.addAction(.init(title: "Отмена", style: .default))
        payInAlert.addAction(.init(title: "Пополнить", style: .cancel) { [weak payInAlert, weak self] _ in
            guard let textField = payInAlert?.textFields?.first,
                  let quantity = textField.text?.toInt64
            else { return }
            if moneyCurrency == .rub {
                self?.payIn(moneyCurrency: moneyCurrency, currency: nil, quantity: quantity, price: nil)
            } else if let currency = self?.currencies?.first(where: { $0.nominal.currency.lowercased() == moneyCurrency.rawValue.lowercased() }) {
                self?.getPrice(moneyCurrency: moneyCurrency, figi: currency.figi) {
                    self?.payIn(moneyCurrency: moneyCurrency, currency: currency, quantity: quantity, price: $0)
                }
            }
        })
        router.present(payInAlert, animated: true)
    }
    
    func getPrice(moneyCurrency: MoneyCurrency, figi: String, _ completion: @escaping (Decimal?) -> Void) {
        guard moneyCurrency != .rub else { return completion(1) }
        interactor.getOrderBook(figi: figi)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
               switch $0 {
               case .failure(let error):
                   self?.handleError(error)
               case .finished:
                   break
               }
             } receiveValue: {
                 completion($0.bids.first?.price.asAmount)
             }
             .store(in: &cancellables)
    }
    
    func payIn(moneyCurrency: MoneyCurrency, currency: Currency?, quantity: Int64, price: Decimal?) {
        let amount: Int64
        var lotsToBuy: Int64?
        if moneyCurrency == .rub {
            amount = quantity
        } else if let lot = currency?.lot {
            guard let price = price else { return }
            lotsToBuy = Int64((CGFloat(quantity) / CGFloat(lot)).rounded(.up))
            // 1.3 - Коэффициент для пополнения рублей с запасом на скупку необходимого количества лотов из нескольких ордеров
            let rubles = Decimal(lotsToBuy!) * Decimal(lot) * price * 1.3
            amount = Int64(truncating: rubles as NSNumber)
        } else {
            return
        }

        isProcessing = true
        interactor.payIn(accountId: account.id, quantity: amount)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .failure(let error):
                    self?.isProcessing = false
                    self?.handleError(error)
                case .finished:
                    if moneyCurrency != .rub,
                       let figi = currency?.figi,
                       let lots = lotsToBuy {
                        self?.buyCurrency(moneyCurrency, figi: figi, quantity: lots) {
                            if let error = $0 {
                                self?.isProcessing = false
                                self?.handleError(error)
                            } else {
                                // Delay to let buyOrder be executed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self?.isProcessing = false
                                    self?.reloadPortfolio()
                                }
                            }
                        }
                    } else {
                        self?.isProcessing = false
                        self?.reloadPortfolio()
                    }
                }
              } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func buyCurrency(_ currency: MoneyCurrency, figi: String, quantity: Int64, _ completion: @escaping (Error?) -> Void) {
        interactor.buy(accountId: account.id, figi: figi, quantity: quantity)
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let error): completion(error)
                case .finished: completion(nil)
                }
              } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

extension AccountPresenter: IAccountPresenter {
    
    var sections: [Section] { [.info, .currencies] }
    
    var infoRows: [InfoRow] {
        return info.canEdit
            ? [.info, .reload, .close]
            : [.info, .reload]
    }

    var info: Info {
        let name = account.name.isEmpty
            ? accountModel?.name ?? ""
            : account.name
        
        return Info(name: name,
                    id: account.id,
                    canEdit: account.name.isEmpty,
                    openedDate: account.openedDate.date)
    }
    
    func numberOfRows(inSection index: Int) -> Int {
        let section = sections[index]
        switch section {
        case .info: return infoRows.count
        case .currencies: return currencyModels.count
        }
    }
    
    func position(at indexPath: IndexPath) -> IAccountPosition? {
        let section = sections[indexPath.section]
        switch section {
        case .info: return nil
        case .currencies: return currencyModels[indexPath.row]
        }
    }
    
    func action(at indexPath: IndexPath) -> IRowAction? {
        let section = sections[indexPath.section]
        switch section {
        case .info:
            let row = infoRows[indexPath.row]
            switch row {
            case .info: return nil
            case .reload: return Action.reload
            case .close: return Action.close
            }
        case .currencies: return nil
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .info:
            let row = infoRows[indexPath.row]
            switch row {
            case .info: return
            case .reload: reloadPortfolio()
            case .close: closeAccount()
            }
        case .currencies: return
        }
    }
    
    func updateAccount(name: String?) {
        accountModel = AccountModel(id: account.id, name: name)
        interactor.updateAccount(id: account.id, name: name)
    }
    
    func payInCurrency(at indexPath: IndexPath) {
        let model = currencyModels[indexPath.row]
        guard isSandbox,
              let currency = MoneyCurrency(rawValue: model.currency)
        else { return }
        payIn(currency: currency)
    }
}
