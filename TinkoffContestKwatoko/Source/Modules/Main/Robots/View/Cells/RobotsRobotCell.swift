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
        infoLabel.text = "\(model.robot.strategy.name) :: \(model.robot.config.figi)"
        actionButton.isSelected = model.isRunning
        onActionToggle = onActionTap
    }
}

private extension RobotsRobotCell {

    func configure() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let runImage = UIImage(systemName: "play.circle.fill", withConfiguration: imageConfig)?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        actionButton.setImage(runImage, for: .normal)
        let stopImage = UIImage(systemName: "stop.circle.fill", withConfiguration: imageConfig)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        actionButton.setImage(stopImage, for: .selected)
        actionButton.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func actionButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        onActionToggle?(sender.isSelected)
    }
}
