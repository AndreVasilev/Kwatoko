//
//  AddRobotListCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

class AddRobotListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String?, value: String?, isEditable: Bool) {
        titleLabel.text = title
        valueLabel.text = value
        accessoryType = isEditable ? .disclosureIndicator : .none
        selectionStyle = isEditable ? .default : .none
    }
}
