//
//  RobotHistoryInfoCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import UIKit

class RobotHistoryInfoCell: UITableViewCell {

    struct Model {
        let title: String?
        let description: String?
        let total: Int
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        totalLabel.text = L10n.Localizable.totalDealsLld(model.total)
    }
}

private extension RobotHistoryInfoCell {

    func configure() {
        selectionStyle = .none
        accessoryType = .detailButton
    }
}
