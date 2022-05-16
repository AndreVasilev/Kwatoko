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

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var askLabel: UILabel!
    @IBOutlet var bidLabel: UILabel!
    @IBOutlet var askStopOrderLabel: UILabel!
    @IBOutlet var bidStopOrderLabel: UILabel!

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
        backgroundColor = model.orderType == .order ? .lightGray : .white
    }
}

private extension OrderBookCell {

    func configure() {
        askLabel.textColor = .red
        askStopOrderLabel.textColor = .red
        bidLabel.textColor = .green
        bidStopOrderLabel.textColor = .green
    }
}
