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
    @IBOutlet weak var complianceLabel: UILabel!
    @IBOutlet weak var whereMyTokensButton: UIButton!

    var onEditingDidEnd: ((Model) -> Void)?
    var onInfoButtonPressed: (() -> Void)?
    
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
        tokenLabel.text = L10n.Localization.tokenExchange
        sandboxTokenLabel.text = L10n.Localization.tokenSandbox

        [tokenTextField, sandboxTokenTextField].forEach {
            $0?.delegate = self
            $0?.isSecureTextEntry = true
            $0?.addTarget(self, action: #selector(didEndEditign), for: .editingDidEnd)
        }

        tokenTextField.returnKeyType = .next
        sandboxTokenTextField.returnKeyType = .done
        
        whereMyTokensButton.setTitle(L10n.Localization.howGetToken, for: .normal)
        whereMyTokensButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        
        complianceLabel.numberOfLines = 0
        complianceLabel.text = L10n.Localization.complianceMessage
    }

    @objc func didEndEditign() {
        let model = Model(token: tokenTextField.text, sandoxToken: sandboxTokenTextField.text)
        onEditingDidEnd?(model)
    }
    
    @objc func infoButtonPressed() {
        onInfoButtonPressed?()
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
