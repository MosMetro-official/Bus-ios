//
//  BusOrder.swift
//  MosmetroNew
//
//  Created by Гусейн on 09.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork
import SwiftDate
import UIKit
import Localize_Swift

struct BusOrdersResponse {
    let page: Int
    let totalPages: Int
    let totalElements: Int
    var orders: [BusOrder]
}

struct BusOrder {
    
    enum BookingStatus: String {
        case created = "N"
        case booked = "B"
        case paid = "S"
        case error = "E"
        case fullyReturned = "R"
        case partiallyReturned = "P"
        case cancelled = "C"
        case partiallyCancelled = "L"
        
        func color() -> UIColor {
            switch self {
            case .created:
                return .textSecondary
            case .booked:
                return .metroGreen
            case .paid:
                return .metroGreen
            case .error:
                return .metroRed
            case .fullyReturned:
                return .textPrimary
            case .partiallyReturned:
                return .metroOrange
            case .cancelled:
                return .metroRed
            case .partiallyCancelled:
                return .metroOrange
            }
        }
        
        func text() -> String {
            switch self {
            case .created:
                return "main_bus_book_status_created".localized(in: Bus.shared.bundle)
            case .booked:
                return "main_bus_book_status_booked".localized(in: Bus.shared.bundle)
            case .paid:
                return "main_bus_book_status_booked".localized(in: Bus.shared.bundle)
            case .error:
                return "main_bus_book_status_error".localized(in: Bus.shared.bundle)
            case .fullyReturned:
                return "main_bus_book_status_fully_returned".localized(in: Bus.shared.bundle)
            case .partiallyReturned:
                return "main_bus_book_status_partially_returned".localized(in: Bus.shared.bundle)
            case .cancelled:
                return "main_bus_book_status_cancelled".localized(in: Bus.shared.bundle)
            case .partiallyCancelled:
                return "main_bus_book_status_partially_cancelled".localized(in: Bus.shared.bundle)
            }
        }
        
        func ticketTextColor() -> UIColor {
            switch self {
            case .created:
                return .invertedText
            case .booked:
                return .warning
            case .paid:
                return .clear
            case .error:
                return .metroRed
            case .fullyReturned:
                return .invertedText
            case .partiallyReturned:
                return .invertedText
            case .cancelled:
                return .metroRed
            case .partiallyCancelled:
                return .metroRed
            }
        }
    }
    
    struct OrderTicket {
        let id: Int
        let internalId: Int
        let barcode: String
        let hash: String
        let price: Int
        let ticketSeries: String
        let ticketCode: String
        let seat: String
        let firstName: String
        let lastName: String
        let middleName: String
        var status: BookingStatus
        
        // MARK: refund info
        var refundedPrice: Double
        var refundDate: Date?
        
        // MARK: From data
        let dispatchAdress: String
        let dispatchStation: String
        let dispatchDate: Date
        
        // MARK: to data
        let arrivalStation: String
        let arrivalDate: Date
        
        var comission: Double {
            return Double(price) - refundedPrice
        }
        
        func docPath() -> String {
            let locale = Localize.currentLanguage() == "ru" ? Locales.russianRussia : Locales.english
            return "main_bus_ticket_save_path".localized(in: Bus.shared.bundle) + " \(dispatchDate.toFormat("d MMMM HH:mm", locale: locale))" + " \(hash)" + ".pdf"
        }
        
        var passengerData: String {
            return "\(lastName) \(firstName) \(middleName)"
        }
        
        static func map(data: JSON) -> OrderTicket? {
            if let id = data["id"].int {
                let dispatchDate = Date(milliseconds: data["dispatchDate"].intValue)
                let arrivalDate = Date(milliseconds: data["arrivalDate"].intValue)
                var refundDate: Date?
                if let refundTimestamp = data["returned"].int {
                    refundDate = Date(milliseconds: refundTimestamp)
                }
                return OrderTicket(id: id,
                                   internalId: data["internalId"].intValue,
                                   barcode: data["barcode"].stringValue,
                                   hash: data["hash"].stringValue,
                                   price: data["price"].intValue,
                                   ticketSeries: data["ticketSeries"].stringValue,
                                   ticketCode: data["ticketCode"].stringValue,
                                   seat: data["seat"].stringValue,
                                   firstName:data["firstName"].stringValue ,
                                   lastName: data["lastName"].stringValue,
                                   middleName: data["middleName"].stringValue,
                                   status: BusOrder.BookingStatus(rawValue: data["status"].stringValue) ?? .created,
                                   refundedPrice: data["repayment"].doubleValue,
                                   refundDate: refundDate,
                                   dispatchAdress: data["dispatchAddress"].stringValue,
                                   dispatchStation: data["dispatchStation"].stringValue,
                                   dispatchDate: dispatchDate,
                                   arrivalStation: data["arrivalStation"].stringValue,
                                   arrivalDate: arrivalDate)
            }
            return nil
        }
    }
    
    struct PaymentInfo {
        let date: Date
        let status: PaymentStatus
        let paymentWay: PaymentWay
        
        enum PaymentStatus: Int {
            case registered = 0
            case sumTaken = 1
            case succesful = 2
            case cancelled = 3
            case returned = 4
            case declined = 6
            
            func color() -> UIColor {
                switch self {
                case .registered:
                    return .textSecondary
                case .sumTaken:
                    return .textSecondary
                case .succesful:
                    return .metroGreen
                case .cancelled:
                    return .metroRed
                case .returned:
                    return .metroLink
                case .declined:
                    return .metroRed
                }
            }
            
            func text() -> String {
                switch self {
                    
                case .registered:
                    return "main_bus_payment_status_registered".localized(in: Bus.shared.bundle)
                case .sumTaken:
                    return "main_bus_payment_status_sum_tak".localized(in: Bus.shared.bundle)
                case .succesful:
                    return "main_bus_payment_status_success".localized(in: Bus.shared.bundle)
                case .cancelled:
                    return "main_bus_payment_status_cancelled".localized(in: Bus.shared.bundle)
                case .returned:
                    return "main_bus_payment_status_returned".localized(in: Bus.shared.bundle)
                case .declined:
                    return "main_bus_payment_status_declined".localized(in: Bus.shared.bundle)
                }
            }
        }
        
        enum PaymentWay: String {
            case card = "CARD"
            case cardBinding = "CARD_BINDING"
            case applePay = "APPLE_PAY"
            case applePayBinding = "APPLE_PAY_BINDING"
            case androidPay = "ANDROID_PAY"
            case androidPayBinding = "ANDROID_PAY_BINDING"
            case googlePayCard =  "GOOGLE_PAY_CARD"
            case googlePayCardBinding = "GOOGLE_PAY_CARD_BINDING"
            case googlePayTokenized = "GOOGLE_PAY_TOKENIZED"
            case googlePayTokenizedBinding = "GOOGLE_PAY_TOKENIZED_BINDING"
            case samsungPay = "SAMSUNG_PAY"
            case samsungPayBinding = "SAMSUNG_PAY_BINDING"
            
            func text() -> String {
                switch self {
                case .card:
                    return "Bank card".localized(in: Bus.shared.bundle)
                case .cardBinding:
                    return "Bank card".localized(in: Bus.shared.bundle)
                case .applePay:
                    return "Apple Pay"
                case .applePayBinding:
                    return "Apple Pay"
                case .androidPay:
                    return "Android Pay"
                case .androidPayBinding:
                    return "Android Pay"
                case .googlePayCard:
                    return "Google Pay"
                case .googlePayCardBinding:
                    return "Google Pay"
                case .googlePayTokenized:
                    return "Google Pay"
                case .googlePayTokenizedBinding:
                    return "Google Pay"
                case .samsungPay:
                    return "Samsung Pay"
                case .samsungPayBinding:
                    return "Samsung Pay"
                }
            }
            
        }
        
        static func map(data: JSON) -> PaymentInfo? {
            if let str = data["date"].string, let timeStamp = Int(str) {
                let date = Date(milliseconds: timeStamp)
                return PaymentInfo(date: date,
                                   status: PaymentStatus(rawValue: data["orderStatus"].intValue) ?? .registered,
                                   paymentWay: PaymentWay(rawValue: data["paymentWay"].stringValue) ?? .card)
            }
            return nil
        }
    }
    
    let gdsID: Int
    let internalID: Int
    let sberbankID: String
    let reserveCode: String
    let totalPrice: Int
    let bookingStatus: BookingStatus
    let tickets: [OrderTicket]
    let paymentInfo: PaymentInfo?
    let createdDate: Date
    var dispatchDate: Date {
        return tickets.first?.dispatchDate ?? Date()
    }
    
    var arrivalDate: Date {
        return tickets.first?.arrivalDate ?? Date()
    }
    
    var route: String {
        if let firstTicket = tickets.first {
            return "\(firstTicket.dispatchStation) – \(firstTicket.arrivalStation)"
        }
        return "\("main_bus_order".localized(in: Bus.shared.bundle)) № \(self.gdsID)"
    }
    
    static func map(data: JSON) -> BusOrder? {
        if let internalID = data["id"].int,
           let gdsID = data["gdsOrderId"].int {
            let paymentInfo = PaymentInfo.map(data: data["paymentStatusInfo"])
            var tickets: [OrderTicket] = []
            if let ticketsArr = data["orderInfo"]["tickets"].array {
                tickets = ticketsArr.compactMap { OrderTicket.map(data: $0) }
            }
            let createdDate = Date(milliseconds: data["createdDate"].intValue)
            
            return BusOrder(gdsID: gdsID,
                            internalID: internalID,
                            sberbankID: data["sberbankOrderId"].stringValue,
                            reserveCode: data["orderInfo"]["reserveCode"].stringValue,
                            totalPrice: data["orderInfo"]["total"].intValue,
                            bookingStatus: BookingStatus(rawValue: data["orderInfo"]["status"].stringValue) ?? .created,
                            tickets: tickets,
                            paymentInfo: paymentInfo,
                            createdDate: createdDate)
            
        }
        return nil
    }
    
}

extension BusOrder {
    // /orders/v1/{orderId}/ticket/return/{ticketId}
    
    func refundTicket(ticket: BusOrder.OrderTicket, callback: @escaping (Result<BusOrder.OrderTicket,FutureNetworkError> ) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .orders, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(self.internalID)/ticket/return/\(ticket.internalId)")
        network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let ticket = BusOrder.OrderTicket.map(data: json["data"]) {
                    callback(.success(ticket))
                    return
                }
                callback(.failure(.jsonParsingError()))
                return
            case .failure(let err):
                callback(.failure(err))
                return
            }
        })
    }
    
    static func getOrder(by orderId: Int, callback: @escaping (Result<BusOrder,FutureNetworkError> ) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .orders, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(orderId)")
        network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let order = BusOrder.map(data: json["data"]) {
                    callback(.success(order))
                    return
                }
                callback(.failure(.jsonParsingError()))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
            
        })
    }
    
    static func getOrders(size: Int = 10, page: Int = 0, callback: @escaping (Result<BusOrdersResponse,FutureNetworkError> ) -> Void) {
        let network = FutureNetworkService()
        let params: [String: Any] = ["size": size,
                      "page": page]
        let body = Request.Body(parameters: params, body: nil)
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .orders, body: body, baseURL: Constants.metro_api, lastComponent: nil)
        network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let ordersArr = json["data"]["items"].array {
                    let orders = ordersArr.compactMap { BusOrder.map(data: $0) }
                    let busOrderResponse = BusOrdersResponse(page: json["data"]["page"].intValue, totalPages: json["data"]["totalPages"].intValue, totalElements: json["data"]["totalElements"].intValue, orders: orders)
                    callback(.success(busOrderResponse))
                    return
                }
                callback(.failure(.jsonParsingError()))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
}
