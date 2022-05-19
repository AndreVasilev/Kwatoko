//
//  OrderBookCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import UIKit

class OrderBookCell: UICollectionViewCell {

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

    func configure(model: OrderBookPresenter.RowModel) {
        priceLabel.text = model.priceString
        switch model.section {
        case .ask:
            askLabel.text = model.quantityString
            bidLabel.text = nil
        case .bid:
            bidLabel.text = model.quantityString
            askLabel.text = nil
        }

        switch model.orderType {
        case .order:
            askStopOrderLabel.text = "<<"
            bidStopOrderLabel.text = ">>"
        case .stopLoss, .takeProfit:
            let label: UILabel
            switch model.section {
            case .ask:
                label = askStopOrderLabel
                bidStopOrderLabel.text = nil
            case .bid:
                label = bidStopOrderLabel
                askStopOrderLabel.text = nil
            }
            label.text = model.orderType?.description
        case .none:
            askStopOrderLabel.text = nil
            bidStopOrderLabel.text = nil
        }

        let color: UIColor
        switch model.orderType {
        case .order: color = .systemGray5
        case .stopLoss: color = .systemRed.withAlphaComponent(0.3)
        case .takeProfit: color = .systemGreen.withAlphaComponent(0.3)
        case .none: color = .systemBackground
        }
        backgroundColor = color
    }
}

private extension OrderBookCell {

    func configure() {
        askLabel.textColor = .systemRed
        bidLabel.textColor = .systemGreen
    }
}
