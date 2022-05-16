//
//  ProfileAccountCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import UIKit

class ProfileAccountCell: UITableViewCell {

    struct Model {
        let title: String?
        let isSelected: Bool
    }

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        titleLabel.text = model.title
        accessoryType = model.isSelected ? .checkmark : .none
    }
}

private extension ProfileAccountCell {

    func configure() {

    }
}
