//
//  ICore.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol ICore {

    var networkService: INetworkService { get }
    var databaseService: IDatabaseService { get }
}
