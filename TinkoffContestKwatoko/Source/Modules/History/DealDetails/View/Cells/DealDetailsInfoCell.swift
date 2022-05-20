//
//  DealDetailsInfoCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import UIKit
import TinkoffInvestSDK

class DealDetailsInfoCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var openDirectionLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    @IBOutlet weak var closeDirectionLabel: UILabel!
    @IBOutlet weak var closePriceLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stopLossLabel: UILabel!
    @IBOutlet weak var takeProfitLabel: UILabel!

    private lazy var dateFormatter = DateFormatter("dd/MM/YYYY")
    private lazy var timeFormatter = DateFormatter("HH:mm:ss")

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(deal: Deal) {
        dateLabel.text = dateFormatter.string(from: deal.date)

        let currencySign = MoneyCurrency(rawValue: deal.currency)?.sign ?? ""

        openTimeLabel.text = timeFormatter.string(from: deal.open.date)
        openDirectionLabel.text = deal.open.direction.title + ":"
        openPriceLabel.text = "\(deal.open.price) \(currencySign)"

        if let order = deal.close {
            closeTimeLabel.text = timeFormatter.string(from: order.date)
            closeDirectionLabel.text = order.direction.title + ":"
            closePriceLabel.text = "\(order.price) \(currencySign)"
        } else {
            closeTimeLabel.text = nil
            closeDirectionLabel.text = nil
            closePriceLabel.text = nil
        }

        profitLabel.text = String(format: "%.3f %%", Double(truncating: deal.profit as NSNumber))
        profitLabel.textColor = deal.profit > 0
            ? .systemGreen
            : deal.profit < 0
                ? .systemRed
                : .systemGray

        quantityLabel.text = "Объем: \(deal.quantity)"
        stopLossLabel.text = "Стоп-лосс: \(deal.stopLoss) \(currencySign)"
        takeProfitLabel.text = "Тейк-профит: \(deal.takeProfit) \(currencySign)"
    }
}

private extension DealDetailsInfoCell {

    func configure() {
        selectionStyle = .none
    }
}

