//
//  OrderBookViewController.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class OrderBookViewController: BaseViewController {

    var presenter: IOrderBookPresenter!

    init(presenter: IOrderBookPresenter) {
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

private extension OrderBookViewController {

    func configure() {

    }
}

extension OrderBookViewController: IOrderBookView {

}
