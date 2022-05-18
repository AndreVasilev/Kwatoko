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
        totalLabel.text = "Всего роботов: \(info.robotsCount)"
        runningLabel.text = "Запущено: \(info.runningCount)"
    }
}

private extension RobotsInfoCell {

    func configure() {
        selectionStyle = .none
    }
}
