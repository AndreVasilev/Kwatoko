//
//  DemoOrderBookInteractor.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation
import TinkoffInvestSDK
import Combine
import CombineGRPC
import SwiftProtobuf

final class DemoOrderBookInteractor {

    let data: Data?
    lazy var dto: OrderBooksDemoDto? = {
        guard let data = self.data else { return nil }
        do {
            return try JSONDecoder().decode(OrderBooksDemoDto.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }()
    
    init(data: Data?) {
        self.data = data
    }
}

extension DemoOrderBookInteractor: IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> AnyPublisher<OrderBook, RPCError> {
        var data = [OrderBook]()
        var interval: Double = 0
        if let dto = self.dto {
            interval = dto.interval
            data = dto.data.map { OrderBook($0, figi: figi) }
        }
        
        return Publishers.Zip(Timer.publish(every: interval, on: .main, in: .default).autoconnect(),
                              data.publisher)
            .map(\.1)
            .setFailureType(to: RPCError.self)
            .eraseToAnyPublisher()
    }
}

fileprivate extension OrderBook {

    init(_ demoDto: OrderBookDemoDto, figi: String) {
        self.init()
        self.figi = figi
        self.depth = Int32(min(demoDto.asks.count, demoDto.bids.count))
        self.asks = demoDto.asks.map(\.toOrder)
        self.bids = demoDto.bids.map(\.toOrder)
        var timestamp = Google_Protobuf_Timestamp()
        timestamp.seconds = Int64(Date().timeIntervalSince1970)
        self.time = timestamp
    }
}

fileprivate extension OrderDemoDto {

    var toOrder: Order {
        var order = Order()
        order.quantity = quantity
        order.price = price.asQuotation
        return order
    }
}
