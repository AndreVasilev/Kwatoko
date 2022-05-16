//
//  IProfileView.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

protocol IProfileView: UIViewController {

    var isProcessing: Bool { get set }

    func reloadData()
}
