//
//  RobotsRobotCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit

class RobotsRobotCell: UITableViewCell {

    typealias Action = (Bool) -> Void

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    var onActionToggle: Action?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: RobotsPresenter.RobotModel, _ onActionTap: @escaping Action) {
        nameLabel.text = model.robot.name
        infoLabel.text = model.robot.description
        actionButton.isSelected = model.isRunning
        onActionToggle = onActionTap
    }
}

private extension RobotsRobotCell {

    func configure() {
        actionButton.isHidden = true
        accessoryType = .detailButton
    }

    @objc func actionButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        onActionToggle?(sender.isSelected)
    }
}
