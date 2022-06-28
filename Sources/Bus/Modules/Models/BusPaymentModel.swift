//
//  BusPaymentModel.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit
import MMCoreNetwork
import SwiftDate

struct BusPaymentModel {
    
    var raceSummary: RaceSummary
    var tickets: [BusTicket]?
    var paymentMethod: BusPaymentMethod
    
    var totalPrice: Int {
        if let tickets = tickets {
            return tickets.reduce(0, { $0 + $1.ticket.price  })
        }
        return 0
    }
    
    func createPaymentRequestBody() -> [String: Any]? {
        guard let tickets = tickets else { return nil }
        let sales: [[String: Any]] = tickets.compactMap { ticket in
            guard let passenger = ticket.passenger else { return nil }
            var phone = ""
            var birthday = ""
            if let _birthday = passenger.birthday {
                let separated = _birthday.split(separator: ".")
                if let day = separated[safe: 0], let month = separated[safe: 1], let year = separated[safe: 2] {
                    birthday = "\(year)-\(month)-\(day)"
                }
            }
            if self.raceSummary.dataRequirments.phoneRequired {
                if let _phone = passenger.phone {
                    var temp = _phone.replacingOccurrences(of: " ", with: "")
                    temp.removeFirst()
                    phone = temp
                }
            }
            return [
                "lastName": passenger.surname ?? "",
                "firstName": passenger.name ?? "",
                "middleName": passenger.middleName ?? "",
                "docTypeCode": "\(passenger.document.code)",
                "docSeries": passenger.document.series ?? 0,
                "docNum": passenger.document.number ?? 0,
                "gender": passenger.gender == .male ? "M" : "F",
                "citizenship": passenger.citizenship?.code ?? "",
                "birthday": birthday,
                "phone": phone,
                "email": "",
                "seatCode": passenger.place?.code ?? "",
                "ticketTypeCode": ticket.ticket.code
            ]
        }
        let final: [String: Any] = [
            "uid": self.raceSummary.race.id,
            "returnUrl": "mosmetro://main/busPaymentSuccess",
            "sales": sales
        ]
        return final
    }
}

struct BusSeat {
    let code: String
    let name: String
    var isSelected: Bool
    
    static func map(data: JSON) -> BusSeat? {
        if let code = data["code"].string {
            let name = data["name"].stringValue.replacingOccurrences(of: "Место ", with: "")
            return BusSeat(code: code, name: name, isSelected: false)
        }
        return nil
    }
}

struct BusPaymentMethod {
    let image: UIImage
    let title: String
    let type: MethodType
    
    enum MethodType {
        case applePay
        case bank
        
        func image() -> UIImage {
            switch self {
            case .applePay:
                return UIImage.getAssetImage(name: "icon.maas.applepay")
            case .bank:
                return UIImage(named: "icon.maas.backcard", in: Bus.shared.bundle, with: nil) ?? UIImage()
            }
        }
    }
}

struct TicketType {
    
    enum TicketClass: String {
        case full = "P"
        case luggage = "B"
    }
    
    let ticketClass: TicketClass
    let name: String
    let price: Int
    let code: String
    
    static func map(data: JSON) -> TicketType? {
        return TicketType(ticketClass: .init(rawValue: data["ticketClass"].stringValue) ?? .full, name: data["name"].stringValue, price: data["price"].intValue, code: data["code"].stringValue)
    }
}

struct BusTicket {

    var ticket: TicketType
    var passenger: Passenger?
    
    static func dummyTicket(availableTickets: [TicketType]) -> BusTicket? {
        guard let firstTicket = availableTickets.first(where: { $0.ticketClass == .full }) else { return nil }
        return BusTicket(ticket: firstTicket, passenger: nil)
    }
}
