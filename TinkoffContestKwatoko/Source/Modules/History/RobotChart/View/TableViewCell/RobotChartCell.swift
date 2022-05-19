//
//  RobotChartCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import UIKit
import Charts

class RobotChartCell: UITableViewCell {

    @IBOutlet weak var chartView: CombinedChartView!

    var presenter: IRobotChartPresenter! {
        didSet { presenter.viewDidLoad() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
}

private extension RobotChartCell {

    func configure() {
        selectionStyle = .none
        chartView.isUserInteractionEnabled = false
    }
}

extension RobotChartCell: IRobotChartView {

}
