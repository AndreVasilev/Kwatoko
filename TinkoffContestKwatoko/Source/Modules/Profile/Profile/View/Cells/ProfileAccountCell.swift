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

        let isCloseEnabled: Bool
    }

    @IBOutlet weak var isSelecedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        isSelecedLabel.isHidden = !model.isSelected
        titleLabel.text = model.title
    }
}

private extension ProfileAccountCell {

    func configure() {
        isSelecedLabel.text = "Текущий"
        isSelecedLabel.textColor = .systemGreen
        accessoryType = .detailButton
    }
}
