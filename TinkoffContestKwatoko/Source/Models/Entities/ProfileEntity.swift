//
//  ProfileEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 17.05.2022.
//

import Foundation

extension ProfileEntity {

    var isAuthorized: Bool {
        return token?.isEmpty == false
            && sandboxToken?.isEmpty == false
    }
}
