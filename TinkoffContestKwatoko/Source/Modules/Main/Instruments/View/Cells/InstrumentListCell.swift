//
//  InstrumentListCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

class InstrumentListCell: UITableViewCell {

    struct Model {
        let name: String?
        let description: String?
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
    }
}

private extension InstrumentListCell {

    func configure() {
        accessoryType = .detailButton
    }
}
