//
//  ContestStrategyConfigCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import UIKit
import TinkoffInvestSDK

class ContestStrategyConfigCell: UITableViewCell {

    enum Direction {
        case both, buy, sell

        var name: String {
            switch self {
            case .both: return "Любое"
            case .buy: return "Покупка"
            case .sell: return "Продажа"
            }
        }

        var sdkValue: OrderDirection {
            switch self {
            case .both: return .unspecified
            case .buy: return .buy
            case .sell: return .sell
            }
        }
    }

    struct Model {
        let name: String?
        let config: IStrategyConfig?
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var orderDirectionLabel: UILabel!
    @IBOutlet weak var edgeQuantityLabel: UILabel!
    @IBOutlet weak var orderQuantityLabel: UILabel!
    @IBOutlet weak var orderDeltaLabel: UILabel!
    @IBOutlet weak var stopLossPercentLabel: UILabel!
    @IBOutlet weak var takeProfitPercentLabel: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthTextField: UITextField!
    @IBOutlet weak var orderDirectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var edgeQuantityTextField: UITextField!
    @IBOutlet weak var orderQuantityTextField: UITextField!
    @IBOutlet weak var orderDeltaTextField: UITextField!
    @IBOutlet weak var stopLossPercentTextField: UITextField!
    @IBOutlet weak var takeProfitPercentTextField: UITextField!

    typealias Action = (Model?) -> Void

    private var onEdit: Action?
    private var config: ContestStrategy.Config?

    private let directions: [Direction] = [.both, .buy, .sell]

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(model: Model?, _ onEdit: @escaping Action) {
        guard let config = model?.config as? ContestStrategy.Config else { return }
        self.config = config
        self.onEdit = onEdit

        nameTextField.text = model?.name
        depthTextField.text = "\(config.depth)"
        edgeQuantityTextField.text = "\(config.edgeQuantity)"
        orderQuantityTextField.text = "\(config.orderQuantity)"
        orderDeltaTextField.text = "\(config.orderDelta)"
        stopLossPercentTextField.text = "\(Int(config.stopLossPercent * 100))"
        takeProfitPercentTextField.text = "\(Int(config.takeProfitPercent * 100))"

        let direction: Direction
        switch config.orderDirection {
        case .buy: direction = .buy
        case .sell: direction = .sell
        default: direction = .both
        }
        if let index = directions.firstIndex(of: direction) {
            orderDirectionSegmentedControl.setEnabled(true, forSegmentAt: index)
        }
    }
}

private extension ContestStrategyConfigCell {

    var editingConfig: IStrategyConfig? {
        guard let config = self.config,
              let depth = depthTextField.text?.toInt,
              depth > 0,
              let edgeQuantity = edgeQuantityTextField.text?.toInt64,
              edgeQuantity > 0,
              let orderQuantity = orderQuantityTextField.text?.toInt64,
              orderQuantity > 0,
              let orderDelta = orderDeltaTextField.text?.toDecimal,
              orderDelta > 0,
              let stopLossPercent = stopLossPercentTextField.text?.toInt,
              stopLossPercent > 0,
              let takeProfitPercent = takeProfitPercentTextField.text?.toInt,
              takeProfitPercent > 0
        else { return nil }

        let orderDirection = directions[orderDirectionSegmentedControl.selectedSegmentIndex].sdkValue

        return ContestStrategy.Config(id: config.id,
                                      accountID: config.accountID,
                                      figi: config.figi,
                                      currency: config.currency,
                                      depth: depth,
                                      orderDirection: orderDirection,
                                      edgeQuantity: edgeQuantity,
                                      orderQuantity: orderQuantity,
                                      orderDelta: orderDelta,
                                      stopLossPercent: Double(stopLossPercent) / 100,
                                      takeProfitPercent: Double(takeProfitPercent) / 100)
    }

    func configure() {
        nameLabel.text = "Название робота"
        depthLabel.text = "Глубина стакана"
        orderDirectionLabel.text = "Направление торговли"
        edgeQuantityLabel.text = "Объем аномальной заявки"
        orderQuantityLabel.text = "Объем торгуемой заявки"
        orderDeltaLabel.text = "Дельта цены заявки"
        stopLossPercentLabel.text = "Стоп-лосс (% от цены заявки)"
        takeProfitPercentLabel.text = "Тейк-профит (% от цены заявки)"

        [nameTextField,
         depthTextField,
         edgeQuantityTextField,
         orderQuantityTextField,
         stopLossPercentTextField,
         takeProfitPercentTextField].forEach {
            $0?.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
            $0?.keyboardType = .numberPad
        }

        orderDeltaTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
        orderDeltaTextField.keyboardType = .decimalPad

        nameTextField.delegate = self

        directions.enumerated().forEach {
            orderDirectionSegmentedControl.setTitle($0.element.name, forSegmentAt: $0.offset)
        }
        orderDirectionSegmentedControl.setEnabled(true, forSegmentAt: 0)
        orderDirectionSegmentedControl.addTarget(self, action: #selector(didEndEditing(_:)), for: .valueChanged)
    }

    @objc func didEndEditing(_ sender: UIControl) {
        guard let name = nameTextField.text,
              !name.isEmpty,
              let config = editingConfig else { return }
        let model = Model(name: name,
                          config: config)
        onEdit?(model)
    }
}

extension ContestStrategyConfigCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
