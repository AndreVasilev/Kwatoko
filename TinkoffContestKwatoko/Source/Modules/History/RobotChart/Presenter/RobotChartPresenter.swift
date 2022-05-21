//
//  RobotChartPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import Charts
import TinkoffInvestSDK

final class RobotChartPresenter: BasePresenter {

    let interactor: IRobotChartInteractor
    let router: IRobotChartRouter
    weak var view: IRobotChartView?

    let deals: [Deal]

    private(set) lazy var profitLabels: [String] = {
        var values = [Double]()
        deals.forEach {
            let number = ($0.profitPriceValue * Decimal($0.quantity)) as NSNumber
            let value = Double(truncating: number) + (values.last ?? 0)
            values.append(value)
        }
        let currencySign = MoneyCurrency(rawValue: deals.first?.currency ?? "")?.sign ?? ""
        return values.map { String(format: "%.2f %@", $0, currencySign) }
    }()

    init(interactor: IRobotChartInteractor, router: IRobotChartRouter, deals: [Deal]) {
        self.interactor = interactor
        self.router = router
        self.deals = deals
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureChart()
    }
}

private extension RobotChartPresenter {

    var chartView: CombinedChartView? { view?.chartView }

    func configureChart() {
//        chartView?.delegate = self
        chartView?.chartDescription.enabled = false
        chartView?.drawBarShadowEnabled = false
        chartView?.highlightFullBarEnabled = false
        chartView?.drawOrder = [CombinedChartView.DrawOrder.bar.rawValue,
                                CombinedChartView.DrawOrder.line.rawValue]
        chartView?.legend.enabled = false


        if let xAxis = chartView?.xAxis {
            xAxis.labelPosition = .bottom
            xAxis.labelFont = .systemFont(ofSize: 13)
            xAxis.drawAxisLineEnabled = false
            xAxis.labelTextColor = .systemGray4
            xAxis.labelCount = 5
            xAxis.centerAxisLabelsEnabled = true
            xAxis.granularity = 1
        }

        if let leftAxis = chartView?.leftAxis {
            leftAxis.drawLabelsEnabled = false
            leftAxis.spaceTop = 0.25
            leftAxis.spaceBottom = 0.25
            leftAxis.drawAxisLineEnabled = false
            leftAxis.drawZeroLineEnabled = true
            leftAxis.zeroLineColor = .systemGray
            leftAxis.zeroLineWidth = 0.7
        }

        updateChartData()
    }

    func updateChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        chartView?.data = data
    }

    func generateLineData() -> LineChartData {
        var yValue: Double = 0
        let entries: [ChartDataEntry] = deals.enumerated().map {
            yValue += Double(truncating: $0.element.profit as NSNumber)
            return ChartDataEntry(x: Double($0.offset) + 0.5,
                                  y: yValue)
        }

        let set = LineChartDataSet(entries: entries, label: "")
        set.setColor(.systemBlue)
        set.lineWidth = 2.5
        set.setCircleColor(.systemBlue)
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = .systemBackground
        set.mode = .cubicBezier
        set.axisDependency = .left
        set.valueFormatter = self

        return LineChartData(dataSet: set)
    }

    func generateBarData() -> BarChartData {

        let entries: [BarChartDataEntry] = deals.enumerated().map {
            return BarChartDataEntry(x: Double($0.offset) + 0.5,
                                     y: Double(truncating: $0.element.profit as NSNumber))
        }
        let colors: [NSUIColor] = entries.map { $0.y > 0 ? .systemGreen : .systemRed }

        let set = BarChartDataSet(entries: entries, label: "")
        set.colors = colors
        set.valueColors = colors

        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 11))

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.barWidth = 0.8

        return data
    }
}

extension RobotChartPresenter: IRobotChartPresenter {

}

extension RobotChartPresenter: ValueFormatter {

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let index = Int(entry.x - 0.5)
        guard index < profitLabels.count else { return "" }
        let string = profitLabels[index]
        return string
    }
}
