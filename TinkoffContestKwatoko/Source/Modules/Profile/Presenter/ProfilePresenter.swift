//
//  ProfilePresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import Combine

final class ProfilePresenter: BasePresenter {

    enum Section {
        case tokens, exchange, sandbox

        var title: String? {
            switch self {
            case .tokens: return nil
            case .exchange: return "Биржа"
            case .sandbox: return "Песочница"
            }
        }
    }

    let interactor: IProfileInteractor
    let router: IProfileRouter
    weak var viewController: IProfileView?

    var cancellables = Set<AnyCancellable>()

    let sections = [Section.tokens, .sandbox, .exchange]

    var exchangeAccounts = [Account]()
    var sandboxAccounts = [Account]()

    init(interactor: IProfileInteractor, router: IProfileRouter) {
        self.interactor = interactor
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = interactor.profile,
           let token = profile.token,
           let sandboxToken = profile.sandboxToken {
            reloadAccounts(token: token, sandboxToken: sandboxToken)
        }
    }
}

extension ProfilePresenter: IProfilePresenter {

    var tokensModel: ProfileTokensCell.Model {
        let profile = interactor.profile
        return ProfileTokensCell.Model(token: profile?.token,
                                       sandoxToken: profile?.sandboxToken)
    }

    func numberOfRows(inSection index: Int) -> Int {
        let section = sections[index]
        switch section {
        case .tokens: return 1
        case .exchange: return exchangeAccounts.count
        case .sandbox: return sandboxAccounts.count
        }
    }

    func accountModel(at indexPath: IndexPath) -> ProfileAccountCell.Model? {
        let profile = interactor.profile
        let account: Account?

        let section = sections[indexPath.section]
        switch section {
        case .tokens: account = nil
        case .exchange: account = exchangeAccounts[indexPath.row]
        case .sandbox: account = sandboxAccounts[indexPath.row]
        }

        let name = account?.name.isEmpty == false ? account?.name : account?.id
        let model = ProfileAccountCell.Model(title: name,
                                             isSelected: account?.id == profile?.selectedAccountId)
        return model
    }

    func updateTokens(model: ProfileTokensCell.Model) {
        guard let token = model.token,
              token.isEmpty == false,
              let sandboxToken = model.sandoxToken,
              sandboxToken.isEmpty == false
        else { return }

        reloadAccounts(token: token, sandboxToken: sandboxToken)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .exchange:
            let account = exchangeAccounts[indexPath.row]
            updateSelectedAccount(id: account.id)
            router.presentAlert(title: "Внимание!",
                                message: "Все сделки будут совершаться на реальной бирже.\nБудьте внимательны с работой работа",
                                actions: [.init(title: "Закрыть", style: .cancel)])
        case .sandbox:
            let account = sandboxAccounts[indexPath.row]
            updateSelectedAccount(id: account.id)
        case .tokens: break
        }
        viewController?.reloadData()
    }
}

private extension ProfilePresenter {

    func reloadAccounts(token: String, sandboxToken: String) {
        viewController?.isProcessing = true

        interactor.prepareSdk(token: token, sandboxToken: sandboxToken)

        interactor.getAccounts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                    self?.viewController?.isProcessing = false
                    self?.viewController?.reloadData()
                case .finished:
                    self?.getSandboxAccounts(token: token, sandboxToken: sandboxToken)
                }
            } receiveValue: { [weak self] in
                self?.exchangeAccounts = $0.accounts
            }.store(in: &cancellables)
    }

    func getSandboxAccounts(token: String, sandboxToken: String) {
        interactor.getSandboxAccounts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.interactor.updateProfile(token: token,
                                                   sandboxToken: sandboxToken,
                                                   accountId: self?.interactor.profile?.selectedAccountId ?? self?.sandboxAccounts.first?.id)
                }
                self?.viewController?.isProcessing = false
                self?.viewController?.reloadData()
            } receiveValue: { [weak self] in
                self?.sandboxAccounts = $0.accounts
            }.store(in: &cancellables)
    }

    func updateSelectedAccount(id: String) {
        guard let profile = interactor.profile,
              let token = profile.token,
              let sandboxToken = profile.sandboxToken
        else { return }
        interactor.updateProfile(token: token, sandboxToken: sandboxToken, accountId: id)
    }
}
