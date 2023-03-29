//
//  RobotsInfoCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

class RobotsInfoCell: UITableViewCell {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(info: RobotsPresenter.Info) {
        totalLabel.text = L10n.Localizable.totalRobotsLld(info.robotsCount)
        runningLabel.text = L10n.Localization.runned(info.runningCount)
    }
}

private extension RobotsInfoCell {

    func configure() {
        selectionStyle = .none

        runningLabel.isHidden = true
    }
}
