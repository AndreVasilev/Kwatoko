//
//  DealDetailsBookOrderCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import UIKit

class DealDetailsBookOrderCell: UITableViewCell {

    struct Model {

        enum ValueType {
            case ask, bid
        }

        let valueType: ValueType
        let value: Int64
        let price: Decimal
    }

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        priceLabel.text = "\(model.price)"
        switch model.valueType {
        case .ask:
            askLabel.text = "\(model.value)"
            bidLabel.text = nil
        case .bid:
            bidLabel.text = "\(model.value)"
            askLabel.text = nil
        }
    }
}

private extension DealDetailsBookOrderCell {

    func configure() {
        selectionStyle = .none
        askLabel.textColor = .systemRed
        bidLabel.textColor = .systemGreen
    }
}
