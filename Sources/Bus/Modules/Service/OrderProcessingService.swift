//
//  OrderProcessingService.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 08.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork

struct OrderBookingResponse {
    let internalOrderID: Int
    let sberbankOrderID: String
    let gdsID: Int
    let url: String
    
    static func map(data: JSON) -> OrderBookingResponse? {
        if let internalID = data["internalId"].int, let sberbankOrderID = data["sberbankOrderId"].string, let gdsID = data["gdsOrderId"].int, let url = data["formUrl"].string {
            return .init(internalOrderID: internalID, sberbankOrderID: sberbankOrderID, gdsID: gdsID, url: url)
        }
        return nil
    }
}

final class OrderProcessingService {
    
    static let shared = OrderProcessingService()
    
    public var onPaymentSuccess: (() -> ())?
    
    var order: OrderBookingResponse?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentSuccess), name: .busPaymentSuccess, object: nil)
    }
    
    @objc private func paymentSuccess() {
        self.onPaymentSuccess?()
    }
    
    public func clear() {
        self.order = nil
    }
}
