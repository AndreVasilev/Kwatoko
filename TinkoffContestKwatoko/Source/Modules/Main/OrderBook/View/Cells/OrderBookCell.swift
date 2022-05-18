//
//  OrderBookCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import UIKit

class OrderBookCell: UICollectionViewCell {

    struct Model {

        enum ValueType {
            case ask, bid
        }

        enum OrderType {
            case order, stopLoss, takeProfit
        }

        let price: String
        let value: String
        let valueType: ValueType
        let orderType: OrderType?

        init(price: String, value: String, valueType: ValueType, orderType: OrderBookCell.Model.OrderType? = nil) {
            self.price = price
            self.value = value
            self.valueType = valueType
            self.orderType = orderType
        }
    }

    static let height: CGFloat = 40

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var askStopOrderLabel: UILabel!
    @IBOutlet weak var bidStopOrderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: OrderBookCell.Model) {
        priceLabel.text = model.price
        switch model.valueType {
        case .ask:
            askLabel.text = model.value
            bidLabel.text = nil
        case .bid:
            bidLabel.text = model.value
            askLabel.text = nil
        }
        askStopOrderLabel.isHidden = model.orderType != .takeProfit
        bidStopOrderLabel.isHidden = model.orderType != .stopLoss
        backgroundColor = model.orderType == .order ? .systemGray5 : .systemBackground
    }
}

private extension OrderBookCell {

    func configure() {
        askLabel.textColor = .systemRed
        askStopOrderLabel.textColor = .systemRed
        bidLabel.textColor = .systemGreen
        bidStopOrderLabel.textColor = .systemGreen
    }
}
