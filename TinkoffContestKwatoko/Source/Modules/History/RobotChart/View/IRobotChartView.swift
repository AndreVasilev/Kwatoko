//
//  IRobotChartView.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import Charts

protocol IRobotChartView: AnyObject {

    var chartView: CombinedChartView! { get }
}
