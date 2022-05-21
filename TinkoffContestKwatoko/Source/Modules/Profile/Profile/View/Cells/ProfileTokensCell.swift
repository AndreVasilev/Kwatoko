//
//  ProfileTokensCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import UIKit

class ProfileTokensCell: UITableViewCell {

    struct Model {
        let token: String?
        let sandoxToken: String?
    }

    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var sandboxTokenLabel: UILabel!
    @IBOutlet weak var sandboxTokenTextField: UITextField!

    var onEditingDidEnd: ((Model) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model) {
        tokenTextField.text = model.token
        sandboxTokenTextField.text = model.sandoxToken
    }
}

private extension ProfileTokensCell {

    func configure() {
        tokenLabel.text = "Токен биржи"
        sandboxTokenLabel.text = "Токен песочницы"

        [tokenTextField, sandboxTokenTextField].forEach {
            $0?.delegate = self
            $0?.isSecureTextEntry = true
            $0?.addTarget(self, action: #selector(didEndEditign), for: .editingDidEnd)
        }

        tokenTextField.returnKeyType = .next
        sandboxTokenTextField.returnKeyType = .done
    }

    @objc func didEndEditign() {
        let model = Model(token: tokenTextField.text, sandoxToken: sandboxTokenTextField.text)
        onEditingDidEnd?(model)
    }
}

extension ProfileTokensCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tokenTextField {
            sandboxTokenTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
