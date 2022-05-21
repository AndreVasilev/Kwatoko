//
//  DealDetailsPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class DealDetailsPresenter: BasePresenter {

    enum Section {
        case info, open, close
    }

    let interactor: IDealDetailsInteractor
    let router: IDealDetailsRouter

    let deal: Deal

    private(set) lazy var sections: [Section] = {
        return [.info, .open] + (deal.close != nil ? [.close] : [])
    }()
    private(set) lazy var openBookOrders: [DealDetailsBookOrderCell.Model]? = bookOrders(from: deal.open)
    private(set) lazy var closeBookOrders: [DealDetailsBookOrderCell.Model]? = bookOrders(from: deal.close)

    init(interactor: IDealDetailsInteractor, router: IDealDetailsRouter, deal: Deal) {
        self.interactor = interactor
        self.router = router
        self.deal = deal
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

private extension DealDetailsPresenter {

    func bookOrders(from order: Deal.Order?) -> [DealDetailsBookOrderCell.Model]? {
        guard let book = order?.closed ?? order?.opened else { return nil }
        let asks = book.asks.map { DealDetailsBookOrderCell.Model(valueType: .ask, value: $0.quantity, price: $0.price) }
        let bids = book.asks.map { DealDetailsBookOrderCell.Model(valueType: .bid, value: $0.quantity, price: $0.price) }
        return asks + bids
    }
}

extension DealDetailsPresenter: IDealDetailsPresenter {

    func numberOfRows(in section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .open: return openBookOrders?.count ?? 0
        case .close: return closeBookOrders?.count ?? 0
        case .info: return 1
        }
    }

    func bookOrderModel(at indexPath: IndexPath) -> DealDetailsBookOrderCell.Model? {
        let section = sections[indexPath.section]
        switch section {
        case .open: return openBookOrders?[indexPath.row]
        case .close: return closeBookOrders?[indexPath.row]
        case .info: return nil
        }
    }

    func titleForSection(_ section: Int) -> String? {
        let section = sections[section]
        switch section {
        case .open: return "Открытие сделки"
        case .close: return "Закрытие сделки"
        case .info: return nil
        }
    }
}
