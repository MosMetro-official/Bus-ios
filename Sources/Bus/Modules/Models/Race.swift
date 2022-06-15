//
//  BusTicketSearchItem.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import SwiftDate
import MMCoreNetwork

struct Carrier {
    let name: String
    let inn: String
}

struct Race {
    let id: String
    let price: Int
    let name: String
    let freeSeats: Int
    let dispatchStationName: String
    let dispatchDate: Date
    let arrivalStationName: String
    let arrivalDate: Date
    let status: Status
    let carrier: Carrier
   
    enum Status: Int {
        case cancelled = 2
        case available = 1
    }
    
    var duration: DateComponents {
        return arrivalDate - dispatchDate
    }
    
    var raceTitle: String {
        return "\(dispatchStationName) – \(arrivalStationName)"
    }
    
    static func map(data: JSON) -> Race? {
        if let id = data["uid"].string {
            let carrier = Carrier(name: data["carrier"].stringValue, inn: data["carrierInn"].stringValue)
            let status = Race.Status(rawValue: data["status"]["id"].intValue)
            let dispatchDate = Date(milliseconds: data["dispatchDate"].intValue)
            let arrivalDate = Date(milliseconds: data["arrivalDate"].intValue)
            
            if status == .cancelled { return nil }
            return Race(id: id,
                        price: data["price"].intValue,
                        name: data["name"].stringValue,
                        freeSeats: data["freeSeatCount"].intValue,
                        dispatchStationName: data["dispatchStationName"].stringValue,
                        dispatchDate: dispatchDate,
                        arrivalStationName: data["arrivalStationName"].stringValue,
                        arrivalDate: arrivalDate,
                        status: status ?? .available,
                        carrier: carrier)
        }
        
        return nil
    }
    
}
