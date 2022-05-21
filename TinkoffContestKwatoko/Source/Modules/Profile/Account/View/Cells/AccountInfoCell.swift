//
//  AccountInfoCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 21.05.2022.
//

import UIKit

class AccountInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    
    private var onEditingDidEnd: ((String?) -> Void)?
    private lazy var dateFormatter = DateFormatter("dd/MM/YYYY")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: AccountPresenter.Info, onEditingDidEnd: @escaping (String?) -> Void) {
        self.onEditingDidEnd = onEditingDidEnd
        nameTextField.text = model.name
        nameTextField.isEnabled = model.canEdit
        idLabel.text = "ID: \(model.id)"
        openDateLabel.text = "Открыт: \(dateFormatter.string(from: model.openedDate))"
    }
}

private extension AccountInfoCell {
    
    func configure() {
        selectionStyle = .none
        
        nameTextField.placeholder = "Название"
        nameTextField.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        nameTextField.delegate = self
    }
    
    @objc func didEndEditing(_ sender: UITextField) {
        onEditingDidEnd?(sender.text)
    }
}

extension AccountInfoCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
