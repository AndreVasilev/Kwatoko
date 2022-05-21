//
//  AccountCurrencyCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 21.05.2022.
//

import UIKit

class AccountCurrencyCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var payInButton: UIButton!
    
    private var onPayIn: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure(model: IAccountPosition, onPayIn: @escaping () -> Void) {
        self.onPayIn = onPayIn
        nameLabel.text = model.name
        valueLabel.text = model.value
        payInButton.isHidden = !((model as? AccountPresenter.CurrencyModel)?.payInEnabled ?? false)
    }
}

private extension AccountCurrencyCell {
    
    func configure() {
        payInButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        onPayIn?()
    }
}
