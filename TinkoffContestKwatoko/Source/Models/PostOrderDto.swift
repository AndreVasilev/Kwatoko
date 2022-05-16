//
//  PostOrderDto.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import Foundation
import TinkoffInvestSDK

struct PostOrderDto {

    let orderID: String
    ///Текущий статус заявки.
    let executionReportStatus: OrderExecutionReportStatus
    ///Запрошено лотов.
    let lotsRequested: Int64
    ///Исполнено лотов.
    let lotsExecuted: Int64
    ///Начальная цена заявки. Произведение количества запрошенных лотов на цену.
    let initialOrderPrice: MoneyValue
    ///Исполненная цена заявки. Произведение средней цены покупки на количество лотов.
    let executedOrderPrice: MoneyValue
    ///Итоговая стоимость заявки, включающая все комиссии.
    let totalOrderAmount: MoneyValue
    ///Начальная комиссия. Комиссия рассчитанная при выставлении заявки.
    let initialCommission: MoneyValue
    ///Фактическая комиссия по итогам исполнения заявки.
    let executedCommission: MoneyValue
    ///Значение НКД (накопленного купонного дохода) на дату. Подробнее: [НКД при выставлении торговых поручений](https://tinkoff.github.io/investAPI/head-orders#coupon)
    let aciValue: MoneyValue
    /// Figi-идентификатор инструмента.
    let figi: String
    ///Направление сделки.
    let direction: OrderDirection
    ///Начальная цена инструмента заявки.
    let initialSecurityPrice: MoneyValue
    ///Тип заявки.
    let orderType: OrderType
    ///Дополнительные данные об исполнении заявки.
    let message: String
    ///Начальная цена заявки в пунктах (для фьючерсов).
    let initialOrderPricePt: Quotation

    let description: String
}

extension PostOrderDto {

    init(response: PostOrderResponse, description: String) {
        orderID = response.orderID
        executionReportStatus = response.executionReportStatus
        lotsRequested = response.lotsRequested
        lotsExecuted = response.lotsExecuted
        initialOrderPrice = response.initialOrderPrice
        executedOrderPrice = response.executedOrderPrice
        totalOrderAmount = response.totalOrderAmount
        initialCommission = response.initialCommission
        executedCommission = response.executedCommission
        aciValue = response.aciValue
        figi = response.figi
        direction = response.direction
        initialSecurityPrice = response.initialSecurityPrice
        orderType = response.orderType
        message = response.message
        initialOrderPricePt = response.initialOrderPricePt

        self.description = description
    }
}
