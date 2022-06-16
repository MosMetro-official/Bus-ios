//
//  TicketSearchModel.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation

struct DepartureSearchModel {
    var country: Country?
    var region: BusRegion?
    var from: Destination?
    
}

struct ArrivalSearchModel {
    var from: Destination
    var to: Destination?
}

struct TicketSearchModel {
    
    enum ModelState {
        case initial
        case loading
        case loaded([Race])
        case error(FutureNetworkError)
    }
    
    var from: DepartureSearchModel?
    var to: ArrivalSearchModel?
    var date: Date?
}
