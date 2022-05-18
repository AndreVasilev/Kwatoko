//
//  StrategyListCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

class StrategyListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(strategy: Strategy) {
        titleLabel.text = strategy.name
    }
}

private extension StrategyListCell {

    func configure() {
        accessoryType = .detailButton
    }
}
