//
//  RobotChartViewController.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import Charts

final class RobotChartViewController: BaseViewController {

    @IBOutlet weak var chartView: CombinedChartView!

    var presenter: IRobotChartPresenter!

    init(presenter: IRobotChartPresenter) {
        self.presenter = presenter
        super.init(output: presenter)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension RobotChartViewController {

    func configure() {
        title = L10n.Localization.chart
    }
}

extension RobotChartViewController: IRobotChartView {

}
