//
//  BusTicketService.swift
//  MosmetroNew
//
//  Created by Гусейн on 06.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork
import SwiftDate
import Fuse
import PDFKit

struct BusRegion: Fuseable {
    let id: Int
    let name: String
    let type: String
    let code: String
    
    var properties: [FuseProperty] {
        return [
            FuseProperty(name: name)
        ]
    }
    
    static func map(data: JSON) -> BusRegion? {
        if let id = data["id"].int {
            return BusRegion(id: id,
                           name: data["name"].stringValue.lowercased().capitalizingFirstLetter(),
                             type: data["type"].stringValue,
                    code: data["code"].stringValue)
        }
        return nil
    }
}

struct Destination: Fuseable {
    let id: Int
    let name: String
    let region: String
    let details: String?
    let adress: String?
    let mapPoint: MapPoint?
    let okato: String
    let place: Bool
    
    var properties: [FuseProperty] {
           return [
            FuseProperty(name: name)
           ]
       }
    
    static func map(data: JSON) -> Destination? {
        if let id = data["id"].int {
            var mapPoint: MapPoint?
            if let latitude = data["latitude"].double, let longitude = data["longitude"].double {
                mapPoint = MapPoint(latitude: latitude, longitude: longitude)
            }
            return Destination(id: id,
                               name: data["name"].stringValue,
                               region: data["region"].stringValue,
                               details: data["details"].string,
                               adress: data["adress"].string,
                               mapPoint: mapPoint,
                               okato: data["okato"].stringValue,
                               place: data["place"].boolValue)
        }
        return nil
    }
}

final class BusTicketService {
    
    @AppData(key: "buses.available", defaultValue: false)
    static var isBusesAvailable: Bool
    
    @AppData(key: "buses.seenPromo", defaultValue: false)
    static var hasSeenOnboarding: Bool
    
    static public func checkAvailability() {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .modulesAvailability, body: nil, baseURL: Constants.metro_api, lastComponent: nil)
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let available = json["data"]["tickets"].bool {
                    self.isBusesAvailable = available
                }
            case .failure(_):
                break
            }
        })
    }
    
    public func setupPaymentObserver() {
        OrderProcessingService.shared.onPaymentSuccess = { [weak self] in
            guard let self = self else { return }
            self.onPaymentSuccess?()
        }
    }
    
    var onPaymentSuccess: (() -> ())?
}

// MARK: – Regions, finding places
extension BusTicketService {
    
    func regions(countryID: Int, callback: @escaping (Result<[BusRegion],FutureNetworkError>) -> Void ) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .regions, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(countryID)")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let regionsArray = json["data"].array {
                    let regions = regionsArray.compactMap { BusRegion.map(data: $0) }
                    callback(.success(regions))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
            
        })
    }
    
    func getDeparturePoints(regionID: Int?, callback: @escaping (Result<[Destination],FutureNetworkError>) -> Void ) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .fromDestination, body: nil, baseURL: Constants.metro_api, lastComponent: regionID == nil ? nil : "/\(regionID!)")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let pointsArray = json["data"].array {
                    let points = pointsArray.compactMap { Destination.map(data: $0) }
                    callback(.success(points))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
    
    func getAvailablePoints(fromID: Int, callback: @escaping (Result<[Destination],FutureNetworkError>) -> Void ) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .toDestination, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(fromID)")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let pointsArray = json["data"].array {
                    let points = pointsArray.compactMap { Destination.map(data: $0) }
                    callback(.success(points))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
}

// MARK: Races
extension BusTicketService {
    
    func findRaces(from: Destination, to: Destination, onDate: Date, callback: @escaping (Result<[Race],FutureNetworkError>) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .races, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(from.id)/\(to.id)/\(onDate.toFormat("YYYY-MM-dd", locale: nil))")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let racesJsonArray = json["data"].array {
                    let races = racesJsonArray.compactMap { Race.map(data: $0) }
                    callback(.success(races))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
    
    func raceSummary(by uid: String, callback: @escaping (Result<RaceSummary,FutureNetworkError>) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .raceSummary, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(uid)")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let raceSummary = RaceSummary.map(data: json["data"]) {
                    callback(.success(raceSummary))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
    
    func raceCarrier(by uid: String, callback: @escaping (Result<[Bool],FutureNetworkError>) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .raceCarrier, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(uid)")
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                print(json)
                print("dsaadsdsa")
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
}

// MARK: Payment
extension BusTicketService {
    func initPayment(body: [String: Any], callback: @escaping (Result<OrderBookingResponse,FutureNetworkError>) -> ()) {
        let network = FutureNetworkService()
        let reqBody = Request.Body(parameters: nil, body: body)
        let req = Request(httpMethod: .POST, httpProtocol: .HTTPS, contentType: .json, endpoint: .bookOrder, body: reqBody, baseURL: Constants.metro_api, lastComponent: nil)
        network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let orderResponse = OrderBookingResponse.map(data: json["data"]) {
                    OrderProcessingService.shared.order = orderResponse
                    callback(.success(orderResponse))
                    return
                }
                let err = FutureNetworkError(statusCode: nil, kind: .invalidJSON, errorDescription: "")
                callback(.failure(err))
                return
            case .failure(let error):
                callback(.failure(error))
                return
            }
        })
    }
    
    public func confirmPayment(callback: @escaping (Result<BusOrder,FutureNetworkError>) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .POST, httpProtocol: .HTTPS, contentType: .json, endpoint: .confirmOrder, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(OrderProcessingService.shared.order?.internalOrderID ?? 0)")
        network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let busOrder = BusOrder.map(data: json["data"]) {
                    callback(.success(busOrder))
                    OrderProcessingService.shared.clear()
//                    AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.paymentSuccess")
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

// MARK: Orders
extension BusTicketService {
    
// file:///var/mobile/Containers/Data/Application/57D4A653-6AB2-4E89-833F-F46597B4B262/Documents/2f691779ba06dea1205019f51abc5f91cd1df8b7.pdf
    
    private func documentExist(path: String) -> URL? {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(path)
            if fileManager.fileExists(atPath: fileURL.path) {
                return fileURL
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    private func saveDocument(path: String, data: Data) -> URL? {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(path)
            fileManager.createFile(atPath: fileURL.path, contents: data)
            return fileURL
        } catch {
            print(error)
            return nil
        }
    }
    
    func loadDocument(ticket: BusOrder.OrderTicket, callback: @escaping (Result<URL,FutureNetworkError> ) -> Void) {
        if let filePath = documentExist(path: ticket.docPath()) {
            callback(.success(filePath))
            print("🤩 FILE EXISTS")
            return
        } else {
            let network = FutureNetworkService()
            let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .busDocument, body: nil, baseURL: Constants.metro_api, lastComponent: "/\(ticket.hash)")
            network.request(req, includeHeaders: true, includeClipHeaders: false, callback: { result in
                switch result {
                case .success(let response):
                    if let data = response.data as? Data, let filePath = self.saveDocument(path: ticket.docPath(), data: data) {
                        callback(.success(filePath))
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
}
