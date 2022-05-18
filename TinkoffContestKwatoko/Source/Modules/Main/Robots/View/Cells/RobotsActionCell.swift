//
//  RobotsActionCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

protocol IRowAction {
    var title: String { get }
    var color: UIColor { get }
}

class RobotsActionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(action: IRowAction) {
        titleLabel.text = action.title
        titleLabel.textColor = action.color
    }
}

private extension RobotsActionCell {

    func configure() {

    }
}
