//
//  BasePresenter.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import CombineGRPC

class BasePresenter: ILifeCycleOutput {
    
    private let router: IBaseRouter
    
    init(router: IBaseRouter) {
        self.router = router
    }
    
    enum ErrorAlertStyle {
        case none, alert, banner
    }
    
    func viewDidLoad() {
        //do nothing
    }

    func viewWillAppear() {
        //do nothing
    }

    func viewDidDisappear() {
        //do nothing
    }

    func viewDidAppear() {
        //do nothing
    }
    
    // MARK: Handling errors
    
    func handleError(_ error: Error) {
        handleError(error, style: .none)
    }
    
    func handleError(_ error: Error, style: ErrorAlertStyle) {
        let text: String
        if let rpcError = error as? RPCError,
           let message = rpcError.trailingMetadata?.first(name: "message") {
            text = message
        } else {
            text = error.localizedDescription
        }
        
        switch style {
        case .none: return
        case .alert: presentErrorAlert(message: text)
        case .banner: presentBanner(text: text)
        }
    }
    
    func presentBanner(text: String) {
        
    }
    
    func presentErrorAlert(title: String? = nil, message: String?) {
        router.presentAlert(title: title,
                            message: message,
                            actions: [.init(title: "Закрыть", style: .default)])
    }
}
