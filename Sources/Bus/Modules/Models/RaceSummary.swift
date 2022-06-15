//
//  RaceSummary.swift
//  MosmetroNew
//
//  Created by Гусейн on 07.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork

struct DataRequirments {
    // нужен мобильный номер
    let phoneRequired: Bool
    // Дата рождения, гендер, гражданство
    let personalDataRequired: Bool
}

struct RaceSummary {
    let race: Race
    let availableDocs: [Passenger.Document]
    let ticketTypes: [TicketType]
    let seats: [BusSeat]
    let dataRequirments: DataRequirments
    
    static func map(data: JSON) -> RaceSummary? {
        
        guard let race = Race.map(data: data["race"]),
              let availableDocs = data["docTypes"].array?.compactMap({ Passenger.Document.map(data: $0) }),
              let ticketTypes = data["ticketTypes"].array?.compactMap({ TicketType.map(data: $0) }),
              let busSeats =  data["seats"].array?.compactMap({ BusSeat.map(data: $0)}) else { return nil }
        
        let dataReqs = DataRequirments(phoneRequired: data["depot"]["phoneRequired"].boolValue, personalDataRequired: data["race"]["dataRequired"].boolValue)
        
        return RaceSummary(race: race, availableDocs: availableDocs, ticketTypes: ticketTypes, seats: busSeats, dataRequirments: dataReqs)
        
    }
    
}
