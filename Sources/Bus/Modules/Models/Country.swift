//
//  Country.swift
//  MosmetroNew
//
//  Created by Гусейн on 14.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import MMCoreNetwork
import Fuse
import Realm
import RealmSwift
import SwiftDate

struct Country: Fuseable {
    
    let id: Int
    let name: String
    let fullName: String
    let code: String
    
    var properties: [FuseProperty] {
        return [
            FuseProperty(name: name)
        ]
    }
    
    static private func countries(callback: @escaping (Result<[Country],FutureNetworkError>) -> Void) {
        let network = FutureNetworkService()
        let req = Request(httpMethod: .GET, httpProtocol: .HTTPS, contentType: .json, endpoint: .countries, body: nil, baseURL: Constants.metro_api, lastComponent: nil)
        network.request(req, callback: { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                if let countriesArray = json["data"].array {
                    let countriesDTO: [CountryDTO] = countriesArray.map {
                        let countryDTO = CountryDTO()
                        countryDTO.map(data: $0)
                        return countryDTO
                    }
                    let realm = try! Realm(configuration: .busConfiguration)
                    let datas = realm.objects(CountryDTOData.self)
                    let countriesToDelete = realm.objects(CountryDTO.self)
                    let newData = CountryDTOData()
                    newData.countries.append(objectsIn: countriesDTO)
                    try! realm.write {
                        realm.delete(datas)
                        realm.delete(countriesToDelete)
                        realm.add(newData)
                    }
                    let countries: [Country] = countriesDTO.map { dto in
                        return Country(id: dto.id, name: dto.name, fullName: dto.fullName, code: dto.code)
                    }
                    callback(.success(countries))
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
    
    static func getCountries(callback: @escaping (Result<[Country],FutureNetworkError>) -> Void) {
        let queue = DispatchQueue(label: "ru.mosmetro.countryFetch", qos: .userInitiated)
        queue.async {
            guard let realm = try? Realm(configuration: .busConfiguration) else {
                callback(.failure(.jsonParsingError()))
                return
            }
            
            // we have countries in local storage and not empty
            if let countryData = realm.objects(CountryDTOData.self).first, !countryData.countries.isEmpty {
                let diff = Date().timeIntervalSince(countryData.createdDate)
                if diff > (5*60) {
                    // we need to load new data
                    countries(callback: { result in
                        switch result {
                        case .success(let countries):
                            callback(.success(countries))
                            return
                        case .failure(let error):
                            callback(.failure(error))
                            return
                        }
                    })
                } else {
                    // get from cache
                    let countries: [Country] = countryData.countries.map { countryDTO in
                        return Country(id: countryDTO.id, name: countryDTO.name, fullName: countryDTO.fullName, code: countryDTO.code)
                    }
                    callback(.success(countries))
                    return
                    
                }
            } else {
                // we need to load new data
                countries(callback: { result in
                    switch result {
                    case .success(let countries):
                        callback(.success(countries))
                        return
                    case .failure(let error):
                        callback(.failure(error))
                        return
                    }
                })
            }
        }
    }
    
    static func map(data: JSON) -> Country? {
        if let id = data["id"].int {
            return Country(id: id,
                           name: data["name"].stringValue.lowercased().capitalizingFirstLetter(),
                           fullName: data["fullName"].stringValue,
                           code: data["code"].stringValue)
        }
        return nil
    }
}

class CountryDTOData: Object {
    @objc dynamic var createdDate: Date = Date()
    let countries = List<CountryDTO>()
}

class CountryDTO: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var code: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func map(data: JSON) {
        if let id = data["id"].int {
            self.id = id
            self.name = data["name"].stringValue.lowercased().capitalizingFirstLetter()
            self.fullName = data["fullName"].stringValue
            self.code = data["code"].stringValue
        }
    }
}
