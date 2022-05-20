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
    @IBOutlet weak var closeButton: UIButton!

    private var onClose: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model, _ onClose: @escaping () -> Void) {
        isSelecedLabel.isHidden = !model.isSelected
        titleLabel.text = model.title
        self.onClose = onClose
        (closeButton.superview ?? closeButton).isHidden = !model.isCloseEnabled
    }
}

private extension ProfileAccountCell {

    func configure() {
        isSelecedLabel.text = "Текущий"
        isSelecedLabel.textColor = .systemGreen

        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc func closeButtonTapped() {
        onClose?()
    }
}
