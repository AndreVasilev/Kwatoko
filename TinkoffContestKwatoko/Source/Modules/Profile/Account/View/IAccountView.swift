//
//  IAccountView.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

protocol IAccountView: UIViewController {
    
    var isProcessing: Bool { get set }

    func reloadData()
}
