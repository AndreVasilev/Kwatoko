//
//  IDatabaseService.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IDatabaseService {

    var profile: ProfileEntity? { get }

    func updateProfile(token: String, sandboxToken: String, accountId: String?)
}
